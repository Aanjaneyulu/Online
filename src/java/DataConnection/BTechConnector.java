/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package DataConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;

/**
 *
 * @author Anji
 */
public class BTechConnector { 
    Connection con;     
    public BTechConnector(String dept) throws IOException{
        try{
            Class.forName("com.mysql.jdbc.Driver");
            String url="jdbc:mysql://localhost:3306/feedback_"+dept;
            con=DriverManager.getConnection(url,"root","GRIETITOLFF1202"); 
            /////////////////
            /*Properties prop = new Properties();
            prop.load(new FileInputStream(System.getProperty("user.home") + "/mydb.cfg"));
            System.out.println("user.home: "+System.getProperty("user.home"));
            String host = prop.getProperty("host").toString();
            String username = prop.getProperty("username").toString();
            String password = prop.getProperty("password").toString();
            String driver = prop.getProperty("driver").toString();
            con = DriverManager.getConnection(host, username, password);
            System.out.println("CONNECTION: " + connection);*/
        }
        catch(Exception e){
            System.out.println(e);
        }
    }   
    public Connection getConnection(){
        return con;
    } 
}
