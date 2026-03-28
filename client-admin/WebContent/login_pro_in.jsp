<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="_inc/inc_head.jsp" %>
<%

request.setCharacterEncoding("utf-8");

String ai_id = getRequest(request.getParameter("ai_id")).toLowerCase();
String ai_pw = getRequest(request.getParameter("ai_pw"));
String url =request.getParameter("url");  // 사용자가 입력하는값이 아니므로trim()안함


if (ai_id == null || ai_id.equals("") || ai_pw == null || ai_pw.equals("")) { 
   out.println("<script>");
   out.println("alert('아이디와 비밀번호를 입력하세요.'); history.back();");
   out.println("</script>");
   out.close();   
}
try{
   stmt = conn.createStatement();
   sql = "select * from t_admin_info where ai_use <> 'c' and ai_id = '" + ai_id + "' and ai_pw = '" + ai_pw + "' ";
   // System.out.println(sql);  
   rs = stmt.executeQuery(sql); //쿼리를 실행
   if(rs.next()) {// 로그인 성공
	   AdminInfo ai = new AdminInfo();
   // 로그인한 회원의 정보들을 저장할 인스턴스 생성
     	ai.setAi_id(ai_id); 
		ai.setAi_pw(ai_pw);
		ai.setAi_idx(rs.getString("ai_idx"));
		ai.setAi_name(rs.getString("ai_name"));
		ai.setAi_use(rs.getString("ai_use"));
		ai.setAi_date(rs.getString("ai_date"));

      session.setAttribute("loginInfo", ai);  // 로그인한 회원정보를 담은 AdminInfo형 인스턴스 mi를 세션에  "loginInfo"라는 속성으로 저장
      response.sendRedirect("tbAdminMemInfo.jsp");    
      
      
   }else { //로그인 실패
      out.println("<script>");
      out.println("alert('아이디와 비밀번호를 확인 후 다시 로그인 하세요.'); history.back();");
      out.println("</script>");
      out.close();
   }
} catch(Exception e) {
   e.printStackTrace();
   
} finally {
   try{
      rs.close();
      stmt.close();
   } catch(Exception e) {
      out.println("로그인 처리시 문제가 발생했습니다.");
      e.printStackTrace();
   }
}
%>
<%@ include file="_inc/inc_foot.jsp" %>