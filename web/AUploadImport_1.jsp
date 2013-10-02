<%-- 
    Document   : AUploadImport
    Created on : Feb 16, 2013, 1:54:51 AM
    Author     : Anji
--%>

<%@page import="java.sql.ResultSet" errorPage="Error.jsp"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>::GRIET</title>
        <link rel="stylesheet" href="CSS/redun.css" />
    </head>
    <body>
        <%if(session.getAttribute("AID")!=null && session.getAttribute("DEPT")!=null){
            try{
                String dtype=request.getParameter("dtype");
                String utype=request.getParameter("utype");
                String dept=(String)session.getAttribute("DEPT");%>
                <center><br /><h2 style="display:inline"><u><%=dtype%> data import</u>:</h2></center>
                <%if(dtype.equals("Student")){
                    if(utype.equals("Import")){
                        if(request.getParameter("importstate")==null){
                            boolean safe=false;
                            int year=Integer.parseInt(request.getParameter("year"));
                            int sections=Integer.parseInt(request.getParameter("sections"));%>
                            <form action="#" method="post">
                                <input type="hidden" name="dtype" value="<%=dtype%>" />
                                <input type="hidden" name="utype" value="<%=utype%>" />
                                <input type="hidden" name="importstate" value="step" />
                                <%String sec[]=new String[4];
                                  int sel=0,i=0;
                                  while(i<4){
                                      char ch=(char)(65+i);
                                      if(request.getParameter("sec"+ch)!=null){
                                          sec[sel]=request.getParameter("sec"+ch);
                                          sel++; 
                                      }
                                      i++;
                                  }
                                  i=0;
                                  while(i<sel){%>
                                    <center><h3><%=dept%> 
                                            <%if(year==1)
                                                out.print("I");
                                            else if(year==2)
                                                out.print("II"); 
                                            else if(year==3)
                                                out.print("III");
                                            else
                                                out.print("IV");
                                            %> 
                                            <%=sec[i]%> Section:
                                            </h3>
                                    </center>
                                    <%String err="";
                                    String fformat=request.getParameter("sec"+sec[i]+"format");
                                    if(fformat==null)
                                        err+="You didn't select File Format!<br />";
                                    String fname=request.getParameter("sec"+sec[i]+"file");
                                    if(fname==null)
                                        err+="You didn't choose the file!<br />";
                                    String fpath=request.getParameter("sec"+sec[i]+"path").trim();
                                    if(fpath.equals(""))
                                        err+="You didn't specify file location!";
                                    int fskip=1;
                                    if(request.getParameter("sec"+sec[i]+"skip")!=null)
                                        fskip=Integer.parseInt(request.getParameter("sec"+sec[i]+"skip"));
                                    String fpass="random";
                                    if(request.getParameter("sec"+sec[i]+"pass")!=null)
                                        fpass=request.getParameter("sec"+sec[i]+"pass");
                                    if(err.equals("")){
                                        int fplen=fpath.length()-1;
                                        char lastchar=fpath.charAt(fplen);
                                        if(lastchar!='\\'||lastchar!='/'){
                                            if(fpath.contains("\\")){
                                                fpath=fpath+"\\";
                                            }
                                            else
                                                fpath=fpath+"/";
                                        }
                                        fpath=fpath+fname;
                                        if(fformat.equals("CSV")){
                                            int fflen=fname.trim().length();
                                            if(fname.trim().toLowerCase().substring(fflen-4, fflen).equals(".csv")){
                                                try{
                                                    FileReader fr=new FileReader(fpath);
                                                    BufferedReader br=new BufferedReader(fr);
                                                    String str=new String();
                                                    int j=0,skip=0,sno=0; 
                                                    String stud[]={"","","",""};
                                                    String stu[];%>
                                                    <table border="3" align="center" cellspacing="0">
                                                    <%while((str=br.readLine())!=null){
                                                        if(skip++<fskip)
                                                            continue;
                                                        stu=str.split(",");
                                                        stud[0]="";stud[1]="";stud[2]="";stud[3]="";
                                                        int flen=stu.length,y=0;
                                                        while(y<4){
                                                            if(y<flen){
                                                                stud[y]=stu[y].trim();
                                                                if(y==2){
                                                                    if(!stud[y].equals("")){
                                                                         int mlen=stud[y].length();
                                                                         if(!stud[y].contains("@"))
                                                                            stud[y]="";
                                                                         else{
                                                                            int alen=stud[y].lastIndexOf("@")+1;
                                                                            String domain=stud[y].substring(alen,mlen);
                                                                            int dlen=mlen-alen; 
                                                                            int ulen=mlen-(dlen+1);
                                                                            if(dlen<6 || ulen<4)
                                                                                stud[y]="";
                                                                         }
                                                                    }
                                                                }
                                                            }
                                                            y++;
                                                        }
                                                        if(stud[0].equals("")||stud[1].equals("")||stud[2].equals(""))
                                                            continue;
                                                        if(j==0){
                                                            j++;%>
                                                            <tr style="background-color: #9999ff"><th>Sno.</th><th>SID</th><th>Name</th><th>EmailId</th><th>MobileNo</th></tr>
                                                        <%}%>
                                                        <tr>
                                                            <td align="center"><%=++sno%></td>
                                                            <td><input type="text" name="sid<%=sec[i]%><%=sno%>" value="<%=stud[0]%>" size="15"/></td>
                                                            <td><input type="text" name="sname<%=sec[i]%><%=sno%>" value="<%=stud[1]%>" size="30"/></td>
                                                            <td><input type="text" name="semail<%=sec[i]%><%=sno%>" value="<%=stud[2]%>" size="30" /></td>
                                                            <td><input type="text" name="smobile<%=sec[i]%><%=sno%>" value="<%=stud[3]%>" size="15" /></td>
                                                        </tr>
                                                    <%}%>
                                                    </table>
                                                    <%br.close();
                                                    fr.close();
                                                    if(j!=0){
                                                        safe=true;%>
                                                        <center><b><span style="color: red">Note:</span>if email id is not in proper format then the corresponding student details will not be imported!</b></center>
                                                        <input type="hidden" name="pass<%=sec[i]%>" value="<%=fpass%>" />
                                                        <input type="hidden" name="sec<%=sec[i]%>" value="<%=sec[i]%>" />
                                                        <input type="hidden" name="scount<%=sec[i]%>" value="<%=sno%>" />
                                                        <br />
                                                    <%}   
                                                    else{%>
                                                        <center>
                                                            <h3 style="display: inline">No records to import!</h3><br /><br />
                                                        </center> 
                                                    <%}
                                                }
                                                catch(Exception e){%>
                                                    <center>
                                                        <span style="color:red">Error:</span><br />
                                                        <%=e%><br /><br />
                                                    </center>
                                                <%}
                                            }
                                            else{%>
                                                 <center>
                                                    <span style="color:red">Error:</span><br />
                                                    File you specified is not in CSV format!<br /><br />
                                                 </center>   
                                            <%}
                                        }
                                        else{
                                            //Other excel formats!
                                        }
                                    }
                                    else{%>
                                      <center>
                                            <span style="color:red"><b><u>Error</u>:</b></span><br />
                                            <b><%=err%></b><br /><br />
                                      </center>  
                                    <%}
                                    i++;
                                  }
                                  if(safe){%>
                                         <center>
                                            <input type="hidden" name="year" value="<%=year%>" />
                                            <input type="hidden" name="sections" value="<%=sections%>" />
                                            <input type="button" value="Back" class="redbutton" onclick="history.go(-1)" />
                                            <input type="submit" value="Continue"  class="redbutton" style="width: 120px;margin-left: 10px" />
                                         </center>
                                  <%}
                                  else{%>
                                     <center>
                                        <input type="button" value="Back" class="redbutton" onclick="history.go(-1)" />
                                     </center>
                                  <%}%>
                            </form>
                        <%} 
                        else{
                            try{ 
                                int year=Integer.parseInt(request.getParameter("year"));
                                int sections=Integer.parseInt(request.getParameter("sections"));
                                String sec[]=new String[4];
                                int sel=0,i=0;
                                while(i<sections){
                                    char ch=(char)(65+i); 
                                    if(request.getParameter("sec"+ch)!=null){
                                        sec[sel]=request.getParameter("sec"+ch);
                                        sel++;
                                    }
                                    i++;
                                }
                                i=0;
                                boolean successflag=false; 
                                while(i<sel){%>
                                    <center><h3><%=dept%> 
                                            <%if(year==1)
                                                out.print("I");
                                            else if(year==2)
                                                out.print("II"); 
                                            else if(year==3)
                                                out.print("III");
                                            else
                                                out.print("IV");
                                            %>
                                            <%=sec[i]%> Section:
                                            </h3>
                                    </center>
                                    <%try{
                                        String passtype=request.getParameter("pass"+sec[i]);
                                        int scount=Integer.parseInt(request.getParameter("scount"+sec[i]));
                                        int j=1; 
                                        boolean flag=false;  
                                        String sql=""; 
                                        String rand[]=new String[62];
                                        int rk=0;
                                        while(rk<62){
                                            if(rk<10){
                                                rand[rk]=""+rk; 
                                            }
                                            else if(rk<36){
                                                char c=(char)(55+rk);
                                                rand[rk]=""+c; 
                                            }
                                            else{
                                                char c=(char)(61+rk);
                                                rand[rk]=""+c;
                                            } 
                                            rk++;
                                        }
                                        while(j<=scount){
                                            String sid=request.getParameter("sid"+sec[i]+j).trim();
                                            String sname=request.getParameter("sname"+sec[i]+j).trim();
                                            String semail=request.getParameter("semail"+sec[i]+j).trim();
                                            String smobile=request.getParameter("smobile"+sec[i]+j).trim();
                                            if(sid.equals("")||sname.equals("")||semail.equals("")){
                                                j++;
                                                continue;
                                            }
                                            if(semail.contains("@")){
                                                int mlen=semail.length();
                                                int alen=semail.lastIndexOf("@")+1;
                                                String domain=semail.substring(alen,mlen);
                                                int dlen=mlen-alen; 
                                                int ulen=mlen-(dlen+1);
                                                if(dlen<6 || ulen<4){
                                                    j++;
                                                    continue;
                                                }
                                            }
                                            else{
                                                j++;
                                                continue;
                                            }
                                            String spass=sid;
                                            if(passtype.equals("random")){
                                                //random password generation
                                                int len=5;
                                                len=(int)(len+4*Math.random());
                                                String kpass="";
                                                int jk=1;
                                                while(jk<=len){
                                                    kpass+=""+rand[(int)(Math.random()*62)]; 
                                                    jk++;
                                                }
                                                spass=kpass;
                                            }
                                            if(!flag){
                                                sql+="('"+sid+"','"+sname+"','"+spass+"',"+year+",'"+sec[i]+"','"+semail+"','"+smobile+"','')";
                                                flag=true; 
                                            }
                                            else
                                                sql+=",('"+sid+"','"+sname+"','"+spass+"',"+year+",'"+sec[i]+"','"+semail+"','"+smobile+"','')";
                                            j++;
                                        }
                                        if(!sql.equals("")){
                                            sql="insert into students (UID,UNAME,PASSWORD,YEAR,SECTION,EMAILID,MOBILE,STATUS) values"+sql;
                                            Class.forName("com.mysql.jdbc.Driver");
                                            String uri="jdbc:mysql://localhost:3306/feedback_"+dept;
                                            Connection con=DriverManager.getConnection(uri,"root","GRIETITOLFF1202");
                                            Statement st=con.createStatement();
                                            int rs=st.executeUpdate(sql);
                                            successflag=true; %>
                                            <center>
                                                <%=rs%> new record(s) got imported successfully!
                                            </center>
                                        <%}
                                        else{%>
                                            <center>
                                                <h3 style="display: inline">No records to import! </h3><br /><br /> 
                                            </center>
                                        <%}
                                    }
                                    catch(Exception e){%>
                                        <center>
                                            <span style="color:red"><b><u>Error</u>:</b></span><br />
                                            <b><%=e%></b><br />
                                      </center>  
                                    <%}
                                    i++;
                                }
                                if(successflag){%>
                                    <center>
                                        <form action="Settings.jsp">
                                            <br /><button type="submit" class="redbutton" style="width: 200px">Go to Home Page</button>
                                        </form>
                                    </center>
                                <%}
                                else{%>
                                    <center>
                                        <form action="Settings.jsp">
                                            <br /><input type="button" value="Back" class="redbutton" onclick="history.go(-1)" />
                                        </form>
                                    </center>                                
                                <%}
                            }
                            catch(Exception e){%>
                                <center>
                                    <span style="color:red"><b><u>Error</u>:</b></span><br />
                                    <b><%=e%></b><br />
                                </center>  
                            <%}
                        }
                    }
                }
                else{
                    if(utype.equals("Import")){
                        if(request.getParameter("importstate")==null){%>  
                            <form action="#" method="post" >
                                <input type="hidden" name="dtype" value="<%=dtype%>" />
                                <input type="hidden" name="utype" value="<%=utype%>" />
                                <input type="hidden" name="importstate" value="step" />
                            <%String err="";
                            String FacFormat=request.getParameter("facformat");
                            if(FacFormat==null)
                                err+="You didn't select File Format!<br />";
                            String FacName=request.getParameter("facfile");
                            if(FacName==null)
                                err+="You didn't choose the file!<br />";
                            String FacPath=request.getParameter("facpath").trim();
                            if(FacPath.equals(""))
                                err+="You didn't specify file location!";
                            int FacSkip=Integer.parseInt(request.getParameter("facskip"));
                            boolean FacClear=false;
                            if(request.getParameter("facclear")!=null)
                                FacClear=true;
                            if(err==""){
                                int fplen=FacPath.length()-1;
                                char lastchar=FacPath.charAt(fplen);
                                if(lastchar!='\\'||lastchar!='/'){
                                    if(FacPath.contains("\\")){
                                        FacPath=FacPath+"\\";
                                    }
                                    else
                                        FacPath=FacPath+"/";
                                }
                                FacPath=FacPath+FacName;%>
                                <input type="hidden" name="facfile" value="<%=FacPath%>" />
                                <input type="hidden" name="facskip" value="<%=FacSkip%>" />
                                <input type="hidden" name="facclear" value="<%=FacClear%>" />
                                <%if(FacFormat.equals("CSV")){
                                  int fflen=FacName.trim().length();
                                  if(FacName.trim().toLowerCase().substring(fflen-4, fflen).equals(".csv")){
                                    try{
                                        int StartFid=0;
                                        if(FacClear==true)
                                            StartFid=1;
                                        else{
                                            Class.forName("com.mysql.jdbc.Driver");
                                            String uri="jdbc:mysql://localhost:3306/feedback_"+dept;
                                            Connection con=DriverManager.getConnection(uri,"root","GRIETITOLFF1202");
                                            Statement statement=con.createStatement();
                                            String sql="select max(fid) as max from faculty";
                                            ResultSet rs=statement.executeQuery(sql);
                                            if(rs.next())
                                                StartFid=rs.getInt("max")+1; 
                                        }
                                        FileReader fr=new FileReader(FacPath);
                                        BufferedReader br=new BufferedReader(fr);
                                        String str=new String();
                                        int i=0,skip=0;
                                        String fd[],fac[]={"","",""};
                                        //String fd[]=new String[4];%>
                                        <input type="hidden" name="start" value="<%=StartFid%>" />
                                        <table align="center" border="3" cellspacing="0" padding="0">
                                        <%while((str=br.readLine())!=null){
                                            if(skip++<FacSkip)
                                                continue; 
                                            fd=str.split(",");
                                            fac[0]="";fac[1]="";fac[2]=""; 
                                            int flen=fd.length,y=0;
                                            while(y<3){
                                                if(y<flen){
                                                    fac[y]=fd[y];
                                                    if(y==1){
                                                        fac[y]=fac[y].trim();
                                                        if(!fac[y].equals("")){
                                                            int mlen=fac[y].length();
                                                            if(!fac[y].contains("@"))
                                                                fac[y]="";
                                                            else{
                                                                int alen=fac[y].lastIndexOf("@")+1;
                                                                String domain=fac[y].substring(alen,mlen);
                                                                int dlen=mlen-alen; 
                                                                int ulen=mlen-(dlen+1);
                                                                if(dlen<6 || ulen<4)
                                                                    fac[y]="";
                                                            }
                                                        }
                                                    }
                                                }
                                                y++;
                                            }
                                            if(fac[0]==""||fac[0].trim().equals("")) 
                                                continue;
                                            if(i==0){ 
                                                i++;%> 
                                                <tr style="background-color: #9999ff"><th>Fid</th><th>Name</th><th>EmailId</th><th>MobileNo</th></tr>
                                            <%}
                                            %>
                                            <tr>
                                                <td align="center"><%=StartFid%></td>
                                                <td><input type="text" name="fname<%=StartFid%>" value="<%=fac[0]%>" size="30"/></td>
                                                <td><input type="text" name="femail<%=StartFid%>" value="<%=fac[1]%>" size="30" /></td>
                                                <td><input type="text" name="fmobile<%=StartFid%>" value="<%=fac[2]%>" size="15" /></td>
                                            </tr>
                                            <%StartFid++; 
                                        }
                                        br.close();
                                        fr.close();%>
                                        </table>
                                        <input type="hidden" name="end" value="<%=StartFid%>" />
                                        <%if(i!=0){%>
                                            <center>
                                                <b><span style="color: red">Note:</span>if email id is not in proper format it will be imported as blank field!</b>
                                                <br /><br /><input type="button" value="Back" class="redbutton" onclick="history.go(-1)" />
                                                <input type="submit" value="Continue"  class="redbutton" style="width: 120px;margin-left: 10px" />
                                            </center>
                                        <%}
                                        else{%>
                                            <center>
                                                <h3 style="display: inline">No records to import!</h3><br /><br />
                                                <input type="button" value="Back" class="redbutton" onclick="history.go(-1)" />
                                            </center> 
                                        <%}
                                    }
                                    catch(Exception e){%>
                                         <center>
                                            <span style="color:red">Error:</span><br />
                                            <%=e%><br /><br />
                                            <input type="button" value="Back" class="redbutton" onclick="history.go(-1)" />
                                         </center>
                                    <%}
                                  }
                                  else{%>
                                    <center>
                                            <span style="color:red">Error:</span><br />
                                            File you specified is not in CSV format!<br /><br />
                                            <input type="button" value="Back" class="redbutton" onclick="history.go(-1)" />
                                    </center>     
                                  <%}
                                }
                                else{
                                    //Other Excel Formats
                                }
                            }
                            else{%>
                                <center>
                                    <span style="color:red"><b><u>Error</u>:</b></span><br />
                                    <b><%=err%></b><br /><br />
                                    <input type="button" value="Back" class="redbutton" onclick="history.go(-1)" />
                                </center>
                            <%}%>
                            </form>
                        <%}
                        else{
                            try{
                                int start=Integer.parseInt(request.getParameter("start"));
                                int end=Integer.parseInt(request.getParameter("end"));
                                int is=start,dups=start,es=end;
                                boolean fclear=Boolean.parseBoolean(request.getParameter("facclear"));
                                String fname=new String(),femail=new String(),fmobile=new String(),sql=new String();
                                while(is<es){
                                    fname=request.getParameter("fname"+is).trim();
                                    if(fname.trim().equals("")){
                                        if(is==es-1){
                                            if(!sql.equals("")){
                                                int slen=sql.length()-1;
                                                sql=sql.substring(0, slen);
                                            }
                                        }
                                        is++;
                                        continue;
                                    }
                                    femail=request.getParameter("femail"+is).trim();
                                    if(!femail.equals("")){
                                        if(femail.contains("@")){
                                            int mlen=femail.length();
                                            int alen=femail.lastIndexOf("@")+1;
                                            String domain=femail.substring(alen,mlen);
                                            int dlen=mlen-alen; 
                                            int ulen=mlen-(dlen+1);
                                            if(dlen<6 || ulen<4)
                                                femail="";
                                        }
                                        else{
                                            femail="";
                                        }
                                    }
                                    fmobile=request.getParameter("fmobile"+is);
                                    if(is<es-1)
                                        sql+="('"+dups+"','"+fname+"','"+femail+"','"+fmobile+"'),";
                                    else
                                        sql+="('"+dups+"','"+fname+"','"+femail+"','"+fmobile+"')";
                                    is++; 
                                    dups++;
                                }
                                if(!sql.equals("")){
                                    sql="insert into faculty (`FID`,`FNAME`,`EMAILID`,`MOBILE`) values"+sql;
                                    //out.print(sql);
                                    Class.forName("com.mysql.jdbc.Driver");
                                    String uri="jdbc:mysql://localhost:3306/feedback_"+dept;
                                    Connection con=DriverManager.getConnection(uri,"root","GRIETITOLFF1202");
                                    Statement st=con.createStatement();%>
                                    <h3><table align="center" cellspacing="0">
                                    <%if(fclear==true){
                                        int re=st.executeUpdate("delete from faculty");%>
                                        <tr><th align="left">existing <%=re%> record(s) deleted successfully!</th></tr>
                                    <%}
                                    int rs=st.executeUpdate(sql);%>
                                        <tr><th align="left"><%=rs%> new record(s) got imported successfully!</th></tr>
                                    </table></h3>
                                    <center>
                                    <form action="Settings.jsp">
                                        <button type="submit" class="redbutton" style="width: 200px">Go to Home Page</button>
                                    </form>
                                    </center>
                                <%}
                                else{%>
                                    <center><h3 style="display: inline">No records to import! </h3><br /><br />
                                        <input type="button" value="Back" class="redbutton" onclick="history.go(-1)" />
                                    </center>
                                <%}
                            }
                            catch(Exception e){%>
                                <center>
                                    <span style="color:red">Error:</span><br />
                                    <%=e%><br /><br />
                                    <input type="button" value="Back" class="redbutton" onclick="history.go(-1)" />
                                </center> 
                            <%}
                        }
                    }
                }
            }
            catch(Exception e){%>
                <center>
                    <span style="color:red">Error:</span><br />
                    <%=e%><br /><br />
                    <input type="button" value="Back" class="redbutton" onclick="history.go(-1)" />
                </center>                
            <%}%>
        <%}
        else{%>
            <form action="./" target="_top" id="autosubmit"  method="post" onload="myfunc()">
                <input type="hidden" name="uaccount" value="Administrator" />
            </form>
            <script type="text/javascript">
                function myfunc () {
                    var frm = document.getElementById("autosubmit");
                    frm.submit();
                }
                window.document.getElementById("autosubmit").onload = myfunc();
            </script>
            <noscript>
                <center>
                <h2>You are not Logged In.
                    Please Login to continue!
                    <form action="./" target="_top" method="post" >
                        <input type="hidden" name="uaccount" value="Administrator" /><br />
                        <button type="submit" class="redbutton">LogIn</button>
                    </form>
                </h2>
                </center>
            </noscript>
       <%}%>
    <noscript>
        <center><h4 style="color:red;"> Java Script is not enabled on your Browser<br />Please enable JavaScript to make the page Interactive</h4></center>
    </noscript>
    </body>
</html>
