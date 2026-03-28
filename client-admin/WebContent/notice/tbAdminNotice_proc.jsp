<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
String ai_idx = request.getParameter("ai_idx");
String caption = request.getParameter("caption");
String nl_ctgr = request.getParameter("nl_ctgr");
String nl_title = getRequest(request.getParameter("nl_title"));
String nl_content = getRequest(request.getParameter("nl_content"));
String nl_isview = request.getParameter("nl_isview");
String kind = request.getParameter("kind");
int idx = 0, result=0;
String args ="";
try{
	if(kind.equals("in") || kind.equals("up")){
		if(nl_title == null || nl_title.equals("") || nl_content == null || nl_content.equals("")){
			out.print("<script>");
			out.print("alert('"+caption+"글을 확인하시오.');");
			out.print("history.back();");
			out.print("</script>");
			out.close();
			return;
		}
		if(kind.equals("in")){//글 등록 시
			System.out.print("Insert");
			stmt = conn.createStatement();
			idx = 1;
			sql ="select max(nl_idx) from t_notice_list";
			rs = stmt.executeQuery(sql);
			if(rs.next())	idx=rs.getInt(1) + 1;
			sql = "insert into t_notice_list values "+
			"("+idx+", "+ai_idx+", '"+nl_ctgr+"', '"+nl_title +"', '"+ nl_content+"', 0, 'y', now())";
		
		}else{//글 수정시
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
			sql = "update t_notice_list set " +	
			"nl_ctgr = '"	+ nl_ctgr + "', " 	 + "nl_title = '"  + nl_title + "', " + "nl_content = '"+ nl_content + "'where nl_idx= "+idx;
		}
	}else if(kind.equals("del")){ //글삭제 시
		caption="삭제";
		idx = Integer.parseInt(request.getParameter("idx"));
		stmt = conn.createStatement();	
		sql = "update t_notice_list set nl_isview = 'n' where nl_idx= "+idx;
		result =stmt.executeUpdate(sql);
	}
	result =stmt.executeUpdate(sql);
	out.print("<script>");
	if(result ==1){
		if(kind.equals("in")) response.sendRedirect("tbAdminNoticeView.jsp?cpage=1&idx="+idx);
		else if(kind.equals("up")) out.print("location.replace('tbAdminNoticeView.jsp" + args + "');");
		else out.print("location.replace('tbAdminNoticeList.jsp');");
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