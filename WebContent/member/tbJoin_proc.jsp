<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp"%>
<%
request.setCharacterEncoding("utf-8");

String kind = request.getParameter("kind");
String mi_id = request.getParameter("mi_id");
String mi_pw = request.getParameter("mi_pw");
String mi_pw2 = request.getParameter("mi_pw2");
String mi_name = request.getParameter("mi_name");
String mi_em1 = request.getParameter("mi_em1");
String mi_em2 = request.getParameter("mi_em2");

String mi_ph1 = request.getParameter("mi_ph1");
String mi_ph2 = request.getParameter("mi_ph2");
String mi_ph3 = request.getParameter("mi_ph3");

String mi_email = mi_em1+"@"+mi_em2;
String mi_phone= mi_ph1+"-"+mi_ph2+"-"+mi_ph3;
String caption ="회원가입",altext="";

if(!mi_pw.equals(mi_pw2)){
   System.out.println(1);
   System.out.println(2);
   out.print("<script>alert('비밀번호가 서로 다릅니다.'); history.back();</script>");
   out.close();
   return;
}
try{
	
	stmt = conn.createStatement();
	if(kind.equals("in")){
		sql = "insert into t_member_info values('"+mi_id+"','"+mi_pw+"','"+mi_name+
				"','"+mi_phone+"','"+mi_email+"', 'a', now())";
		altext = "<script>alert('"+mi_name+"님 회원가입을 축하드립니다.'); location.replace('/talkbox/tbMain.jsp');</script>";
	}else if(kind.equals("up")){
		sql= "update t_member_info set mi_pw='"+mi_pw+"', mi_phone='"+mi_phone+
				"', mi_email='"+mi_email+"' where mi_id='"+mi_id+"'";
		altext = "<script>alert('회원 정보가 변경되었습니다.\\n 다시 로그인 해주세요.'); location.replace('/talkbox/tbLogout.jsp');</script>";
		caption ="개인정보변경";
	}
	
	System.out.print(sql);
	int result =stmt.executeUpdate(sql);
	if(result ==1){
		out.print(altext);
		//response.sendRedirect(ROOT_URL);
	} else{
		out.print("<script>alert('"+caption+" 등록에 실패했습니다.\n다시 시도하세요.');</script>");
		out.close();
		return;
	}
}catch(Exception e){
	out.println("로그인 처리시 문제가 발생했습니다.");
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