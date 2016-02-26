package org.wildfly.swarm.examples.jpajaxrscdi;

import org.jboss.shrinkwrap.api.ShrinkWrap;
import org.jboss.shrinkwrap.api.asset.ClassLoaderAsset;
import org.wildfly.swarm.container.Container;
import org.wildfly.swarm.datasources.DatasourcesFraction;
import org.wildfly.swarm.jaxrs.JAXRSArchive;
import org.wildfly.swarm.jpa.JPAFraction;


public class Main {
    public static void main(String[] args) throws Exception {
        Container container = new Container();

        container.fraction(new DatasourcesFraction()
                        .jdbcDriver("com.mysql", (d) -> {
                            d.driverClassName("com.mysql.jdbc.Driver");
                            d.xaDatasourceClass("com.mysql.jdbc.jdbc2.optional.MysqlXADataSource");
                            d.driverModuleName("com.mysql");
                        })
                        .dataSource("MyDS", (ds) -> {
                            ds.driverName("com.mysql");
                            ds.connectionUrl("jdbc:mysql://mysql-service:3306/userdb");
                            ds.userName("itwb");
                            ds.password("itwb");
                        })
        );

        // Prevent JPA Fraction from installing it's default datasource fraction
        container.fraction(new JPAFraction()
                        .inhibitDefaultDatasource()
                        .defaultDatasource("jboss/datasources/MyDS")
        );

        container.start();

        JAXRSArchive deployment = ShrinkWrap.create(JAXRSArchive.class);
        deployment.addClasses(Employee.class);
        deployment.addClasses(Error.class);
        deployment.addAsWebInfResource(new ClassLoaderAsset("META-INF/persistence.xml", Main.class.getClassLoader()), "classes/META-INF/persistence.xml");
        deployment.addResource(EmployeeResource.class);
        deployment.addAllDependencies();

        container.deploy(deployment);
    }
}
