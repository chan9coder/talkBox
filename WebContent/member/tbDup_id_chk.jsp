<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp"%>
<%
/*
1. 사용자가 입력한 아이디를 받아옴
2. 받아온 아이디와 동일한 아이디가 회원 테이블에 있는지 여부를 검사하기 위해 쿼리 생성 후 실행
3. 중복여부를 현 파일을 포함하고 있는 join_form.jsp에서 표시해줌

*/
request.setCharacterEncoding("utf-8");
String mi_id = request.getParameter("mi_id");
try{
	sql="select 1 from t_member_info where mi_id='"+mi_id+"' ";
	stmt =conn.createStatement();
	rs = stmt.executeQuery(sql);
%>
<script>
	var msg = parent.document.getElementById("msg");
	var isDup = parent.frmJoin.isDup;
<%	if(rs.next()){%>
	var tmp ="<span style='color:red; font-weight:bold;'>" +
	"이미 사용중인 아이디 입니다.</span>";
	isDup.value="n";
<%	} else{%>
	var tmp ="<span style='color:blue; font-weight:bold;'>" +
	"사용할 수 있는 아이디 입니다.</span>";
	isDup.value="y";
<%	}%>
	msg.innerHTML =tmp;
	
</script>
<%
	out.println("</script>");
}catch(Exception e){
	out.print("아이디 중복 검사에서 문제가 생겼습니다.");
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