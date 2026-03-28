<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="_inc/inc_head.jsp"%>
<%
if(isLogin){	//이미 로그인이 되어 있다면
	session.invalidate();
	response.sendRedirect("/talkboxAdmin/tbAdminLoginForm.jsp");
	
}
request.setCharacterEncoding("utf-8");
String ai_id= getRequest(request.getParameter("ai_id")).toLowerCase();
String ai_pw= getRequest(request.getParameter("ai_pw"));
String url= request.getParameter("url");

if (ai_id == null || ai_id.equals("") || ai_pw == null || ai_pw.equals("")){
	out.print("<script>");
	out.print("alert('아이디와 비밀번호를 입력하세요.'); history.back();");
	out.print("</script>");
	out.close();
}

try{
	stmt = conn.createStatement();
	sql = "select*from t_admin_info where ai_id= '"+ai_id+"' and ai_pw = '"+ai_pw+"'";
	System.out.println(sql);
	rs =stmt.executeQuery(sql);
	
	if(rs.next()){	// 로그인 성공시
		AdminInfo ai = new AdminInfo();
		// 로그인한 회원의 정보들을 저장할 인스턴스 생성			
		ai.setAi_id(ai_id); 
		ai.setAi_pw(ai_pw);
		ai.setAi_idx(rs.getString("ai_idx"));
		ai.setAi_name(rs.getString("ai_name"));
		ai.setAi_use(rs.getString("ai_use"));
		ai.setAi_date(rs.getString("ai_date"));
		
		session.setAttribute("loginInfo", ai);
		//로그인한 회원 정보를 담은 MemberInfo형 인스턴스 mi를 
		//세션에 "loginInfo"라는 이름의 속성으로 저장
		response.sendRedirect(url);
		System.out.print(url);
		
	} else{		//로그인 실패시
		out.print("<script>");
		out.print("alert('아이디와 비밀번호를 확인 후 다시 로그인하세요.'); history.back();");
		out.print("</script>");
		out.close();
	}
	
}catch(Exception e){
	out.print("로그인 처리시 문제가 발생했습니다.");
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
<%@ include file="_inc/inc_foot.jsp"%>

