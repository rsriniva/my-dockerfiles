package org.wildfly.swarm.examples.jpajaxrscdi;

import javax.enterprise.context.ApplicationScoped;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.PathParam;

import java.net.HttpURLConnection;

@Path("/reports")
@ApplicationScoped
public class EmployeeResource {

    @PersistenceContext(unitName="primary")
    EntityManager em;

    @GET
    @Produces("application/json")
    public Employee[] get() {
        return em.createNamedQuery("Employee.findAll", Employee.class).getResultList().toArray(new Employee[0]);
    }
    
    @GET
	@Path("/{id}")
	@Produces("application/json")
	public Employee getEmployee(@PathParam("id") int id)
	{
		try
		{
			System.out.println( "Fetching Employee ID " + id );
			Employee emp = em.find( Employee.class, id );
			if( emp == null )
			{
				throw new Error( HttpURLConnection.HTTP_NOT_FOUND, "Employee not found" ).asException();
			}
			return emp;
		}
		catch( RuntimeException e )
		{
			throw new Error( HttpURLConnection.HTTP_INTERNAL_ERROR, e ).asException();
		}
	}
}
