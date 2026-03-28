package vo;

import java.sql.*;
import javax.sql.*;
import java.net.*;
import java.time.*;
import java.util.*;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

@WebServlet("/uploadfileproc")
@MultipartConfig(
		fileSizeThreshold = 0,
		location = "E:\\kck\\web\\talkboxAdmin\\WebContent\\upload"
)

public class uploadFileProc extends HttpServlet {
	String driver = "com.mysql.cj.jdbc.Driver";
	String dburl = "jdbc:mysql://localhost:3306/talkbox?useUnicode=true&" + 
		"characterEncoding=UTF8&verifyServerCertificate=false&" + 
		"useSSL=false&serverTimezone=UTC";
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	String sql = null;
	int idx=0, result=0;
	String args ="";
	private static final long serialVersionUID = 1L;
	public String getRequest(String req){
		if(req!=null){
			return req.trim().replace("<", "&lt;");	
		}
		return"";
	}
    public uploadFileProc() {super();}
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	request.setCharacterEncoding("utf-8");
		String caption = request.getParameter("caption");
		String kind = request.getParameter("kind");
		String ai_idx = request.getParameter("ai_idx");
		String pl_title = getRequest(request.getParameter("pl_title"));
		String pl_content = getRequest(request.getParameter("pl_content"));
		System.out.println("Ai_IDX:"+ai_idx);
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		String pl_fname = ""; // 업로드한 파일들의 이름을 누적하여 저장할 변수
		for (Part part : request.getParts()) {
			if (part.getName().startsWith("file")) {
			String cd = part.getHeader("content-disposition");
			String uploadName = getUploadFileName(cd);
				if (!uploadName.equals("")) {
					pl_fname += ", " + uploadName;
					part.write(uploadName);
				}
			}
		}
		if(!pl_fname.equals("")) {
			pl_fname = pl_fname.substring(2);
		}
		try {
			if(kind.equals("in") || kind.equals("up")) {		
				if(pl_title == null || pl_title.equals("") || pl_content == null || pl_content.equals("")){
		    		out.print("<script>alert('"+caption+"록글을 확인하시오.');\nhistory.back();</script>");
		    		return;
		    	}
				dbconnect();
				if(kind.equals("in")){//글 등록 시
					System.out.print("Insert");
					caption="등록";
					stmt = conn.createStatement();
					idx = 1;	
					sql ="select max(pl_idx) from t_pds_list";
					rs = stmt.executeQuery(sql);
					if(rs.next())	idx=rs.getInt(1) + 1;
					sql = "insert into t_pds_list (ai_idx, pl_title, pl_content, pl_fname) values('"+ai_idx+"', '"
							+ pl_title +"', '"+ pl_content+"', '"+pl_fname+"')";
				}else if(kind.equals("up")){//글 수정시
					caption="수정";
					int cpage = Integer.parseInt(request.getParameter("cpage")); 
					idx = Integer.parseInt(request.getParameter("idx"));
					String schtype = request.getParameter("schtype");		// 검색조건
					String keyword = request.getParameter("keyword");		// 검색어
					args = "?cpage="+cpage + "&idx=" + idx;
					if(!(schtype == null || schtype.equals("") || keyword == null || keyword.equals(""))){	//검색을 하지 않는 경우
						args += "&schtype="+ schtype + "&keyword=" + keyword;
					}
					System.out.println("Update");
					stmt = conn.createStatement();	
					if(pl_fname== null || pl_fname.equals("")) {
						sql = "update t_pds_list set pl_title = '"  + pl_title + "', " + 
								"pl_content = '"+ pl_content + "' where pl_idx= "+idx;
					}else {
					sql = "update t_pds_list set pl_fname = '"	+ pl_fname + "', " 	 + "pl_title = '"  + pl_title + "', " + 
							"pl_content = '"+ pl_content + "' where pl_idx= "+idx;
					}
				}
			}else if(kind.equals("del")){ //글삭제 시
				caption="삭제";
				idx = Integer.parseInt(request.getParameter("idx"));
				stmt = conn.createStatement();	
				sql = "update t_pds_list set pl_isview = 'n' where pl_idx= "+idx;
				out.print(sql);
				result =stmt.executeUpdate(sql);
			}
			result =stmt.executeUpdate(sql);
			out.print("<script>");
			if(result ==1){
				if(kind.equals("in")) response.sendRedirect("pbs/tbAdminPDSView.jsp?cpage=1&idx="+idx);
				else if(kind.equals("up")) out.print("location.replace('pbs/tbAdminPDSView.jsp" + args + "');");
				else out.print("location.replace('pbs/tbAdminPDSList.jsp');");
			} else {
				out.print("alert('자료실  "+ caption + "에 실패했습니다.\n다시 시도하세요.');");
				out.print("history.back();");
			}
			out.print("</script>");
			
		} catch(Exception e){
			out.println("자료실 "+caption+"시 문제가 발생했습니다.");
			e.printStackTrace();
		}finally{
		try{
			if(kind.equals("in")) rs.close();
			stmt.close();
		} catch(Exception e){
			e.printStackTrace();
			}
		}
    }
    private String getUploadFileName(String cd) {
		String uploadName = null;
		String[] arrContent = cd.split(";");
		
		int fIdx = arrContent[2].indexOf("\"");
		int sIdx = arrContent[2].lastIndexOf("\"");
		
		uploadName = arrContent[2].substring(fIdx + 1, sIdx);
		return uploadName;
	}
    public void dbconnect() {
    	try {
    		Class.forName(driver);
    		conn = DriverManager.getConnection(dburl, "root", "1234");
    		System.out.println("DB연결 성공");
    	} catch(Exception e) {
    		System.out.println("DB연결에 문제가 발생했습니다.");
    		e.printStackTrace();
    	}
    	
    }
}
