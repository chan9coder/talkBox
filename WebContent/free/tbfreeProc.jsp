<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
String fl_ismem = "y";
String fl_writer = "";
String fl_pw = "";
String fl_title= getRequest(request.getParameter("fl_title"));
String fl_content= getRequest(request.getParameter("fl_content"));
String fl_ip= request.getRemoteAddr();
String kind = request.getParameter("kind");
String caption = request.getParameter("caption");
int idx = 0, result=0;
String args ="";
try{
	if(kind.equals("in") || kind.equals("up")){
		if(fl_title == null || fl_title.equals("") || fl_content == null || fl_content.equals("")){
			out.print("<script>");
			out.print("alert('"+caption+"글을 확인하시오.');");
			out.print("history.back();");
			out.print("</script>");
			out.close();
			return;
		}
		if(kind.equals("in")){//글 등록 시
			fl_writer=loginInfo.getMi_id();
			fl_pw=loginInfo.getMi_pw();	
			if(!isLogin){
				fl_writer = request.getParameter("fl_writer");
				fl_ismem = "n";
			}
			System.out.print("Insert");
			stmt = conn.createStatement();
			idx = 1;
			sql ="select max(fl_idx) from t_free_list";
			rs = stmt.executeQuery(sql);
			if(rs.next())	idx=rs.getInt(1) + 1;
			sql = "insert into t_free_list values ('"+idx+"', '"+fl_ismem+"', '"+fl_writer+"', '"+fl_pw+"', '"+
			fl_title+"', '"+fl_content+"', 0, 0, '"+fl_ismem+"', now())";			
		
		}else{//글 수정시
			int cpage = Integer.parseInt(request.getParameter("cpage")); 
			idx = Integer.parseInt(request.getParameter("idx"));
			String schtype = request.getParameter("schtype");		// 검색조건
			String keyword = request.getParameter("keyword");		// 검색어
			args = "?cpage="+cpage + "&idx=" + idx;
			if(!(schtype == null || schtype.equals("") || keyword == null || keyword.equals(""))){	//검색을 하지 않는 경우
				args += "&schtype="+ schtype + "&keyword=" + keyword;
			}
			
			//System.out.println("Update");
			//stmt = conn.createStatement();	
			//sql = "update t_free_list set " +	
			
		}
	}else if(kind.equals("del")){ //글삭제 시
		caption="삭제";
		idx = Integer.parseInt(request.getParameter("idx"));
		stmt = conn.createStatement();	
		sql = "update t_free_list set fl_isview = 'n' where fl_idx= "+idx;
		result =stmt.executeUpdate(sql);
	}
	result =stmt.executeUpdate(sql);
	out.print("<script>");
	if(result ==1){
		if(kind.equals("in")) response.sendRedirect("tbfreeView.jsp?cpage=1&idx="+idx);
		else if(kind.equals("up")) out.print("location.replace('tbfreeView.jsp" + args + "');");
		else out.print("location.replace('tbfreeList.jsp');");
		}
	 else{
		out.print("alert('공지 글 "+ caption + "에 실패했습니다.\n다시 시도하세요.');");
		out.print("history.back();");
	}
	out.print("</script>");
} catch(Exception e){
	out.println("공지사항 "+caption+"시 문제가 발생했습니다.");
	e.printStackTrace();
}finally{
try{
	rs.close();
	stmt.close();
} catch(Exception e){
	e.printStackTrace();
	}
}

%>
<%@ include file="../_inc/inc_foot.jsp"%>