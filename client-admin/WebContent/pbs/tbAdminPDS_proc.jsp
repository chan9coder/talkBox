<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
String caption = request.getParameter("caption");
String kind = request.getParameter("kind");
String pl_fname = request.getParameter("pl_fname");
String pl_title = getRequest(request.getParameter("pl_title"));
String pl_content = getRequest(request.getParameter("pl_content"));
String pl_isview = request.getParameter("pl_isview");
out.print(kind);
int idx = 0, result=0;
String args ="";
try{
	if(kind.equals("in") || kind.equals("up")){
		if(pl_title == null || pl_title.equals("") || pl_content == null || pl_content.equals("") || pl_fname == null || pl_fname.equals("")){
			out.print("<script>");
			out.print("alert('"+caption+"글을 확인하시오.');");
			out.print("history.back();");
			out.print("</script>");
			out.close();
			return;
		}
		if(kind.equals("in")){//글 등록 시
			System.out.print("Insert");
			caption="등록";
			stmt = conn.createStatement();
			idx = 1;	
			sql ="select max(pl_idx) from t_pds_list";
			rs = stmt.executeQuery(sql);
			if(rs.next())	idx=rs.getInt(1) + 1;
			sql = "insert into t_pds_list (ai_idx, pl_title, pl_content, pl_fname) values('"+'1'+"', '"
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
			sql = "update t_pds_list set pl_fname = '"	+ pl_fname + "', " 	 + "pl_title = '"  + pl_title + "', " + 
					"pl_content = '"+ pl_content + "' where pl_idx= "+idx;
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
		if(kind.equals("in")) response.sendRedirect("tbAdminPDSView.jsp?cpage=1&idx="+idx);
		else if(kind.equals("up")) out.print("location.replace('tbAdminPDSView.jsp" + args + "');");
		else out.print("location.replace('tbAdminPDSList.jsp');");
		}
	 else{
		out.print("alert('자료실  "+ caption + "에 실패했습니다.\n다시 시도하세요.');");
		out.print("history.back();");
	}
	out.print("</script>");
} catch(Exception e){
	out.println("자료실 "+caption+"시 문제가 발생했습니다.");
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