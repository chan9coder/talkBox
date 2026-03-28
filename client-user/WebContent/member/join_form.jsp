<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp"%>
<%
String kind = request.getParameter("kind");
String to ="", name ="", caption="개인 정보수정";
String mi_pw ="", onkeyID="", onkeyPW="";
String[] arrEmail = new String[] {"", ""}; 
String[] arrPhone = new String[] {"", "", ""};

if(kind.equals("in")){
	caption="회원가입";
	//onkeyPW = "onkeyup='dupPW(this.value);'";
	
}else if(kind.equals("up")){
	arrEmail =loginInfo.getMi_email().split("@");
	arrPhone =loginInfo.getMi_phone().split("-");
	mi_pw = loginInfo.getMi_pw();
}else{
	out.print("<script>alert('잘못된 접근');location.replace('/talkbox/tbMain.jsp');</script>");
	out.close();
	return;
}
%>

<iframe src ="" id="dup" style="width:500px; height:200px; border:1px black solid; display:none"></iframe>

<form name="frmJoin" action= "tbJoin_proc.jsp" method="post" onsubmit="return chkVal(this);">

<h2 align="center"><%=caption %></h2>

<input type="hidden" name="isDup" value="n" />
<!-- 중복검사 여부와 사용가능 여부를 저장할 hidden객체 -->
<style>
#memform{
	display: inline-block;
	position: absolute; left: 660px; top: 250px;
	border:none;
}
#twobtn{
	display: inline-block;
	position: absolute; left: 660px; top: 550px;
	border:none;
}

</style>
<div id="memform"align="center">
<table width="600" cellpadding="5" id="MemForm" border="1">
<tr>

<th width="100">아아디</th>
<% if(kind.equals("in")){ %>
<script>
	function dupID(id){
		if(id.length > 3){
			var dup = document.getElementById("dup");
			dup.src = "tbDup_id_chk.jsp?mi_id="+id;
		} else{	//입력한 아이디가 4글자 미만일 경우
			var msg = document.getElementById("msg");
			msg.innerHTML = "아이디는 4~20자 이내로 입력하세요.";
		}
	}
	function chkVal(frm){
		var isDup = frm.isDup.value;
		if(isDup == "n"){
			alert("아이디 중복확인을 하세요.");
			frm.mi_id.focus();
			return false;	
		}
		var mi_pw = frm.mi_pw.value;
		var mi_pw2 = frm.mi_pw2.value;
		var mi_name = frm.mi_name.value;
		
		var mi_em1 = frm.mi_em1.value;
		var mi_em2 = frm.mi_em2.value;
		
		var mi_ph1 = frm.mi_ph1.value;
		var mi_ph2 = frm.mi_ph2.value;
		var mi_ph3 = frm.mi_ph3.value;
		
		if(mi_pw == ""){
			alert("비밀번호를 입력하세요.");
			frm.mi_pw.focus();
			return false;	
		}else if(mi_pw != mi_pw2){
			alert("비밀번호를 다시 확인하세요.");
			frm.mi_pw2.focus();
			return false;
		}
		if(mi_em1=="" || mi_em2=="" || mi_ph1=="" || mi_ph2=="" || mi_ph3==""){
			alert("작성란을 확인해 주세요.");
			return false;
		}
		
		return true;
	}
</script>
<td width="*">
	<input type="text" name="mi_id" onkeyup="dupID(this.value);" maxlength ="20"/><br />
	<span id="msg">아이디는 4~20자 이내로 입력하세요.</span>
</td>
</tr>
<%
name="<input type='text' name='mi_name' />";
} else {
		to="새 ";
		name="<label>"+loginInfo.getMi_name()+ "</label><br />";
		caption="변경";
%>
<td width="*">
	<label><%=loginInfo.getMi_id() %></label><br />
	<input type="hidden" name="mi_id" value="<%=loginInfo.getMi_id() %>" />
	<input type="hidden" name="mi_name" value="<%=loginInfo.getMi_name() %>" />
</td>
</tr>
<%} %>
<tr><th><%=to %>비밀번호</th><td><input type="password" name="mi_pw" value="<%=mi_pw %>" /></td></tr>
<tr><th><%=to %>비밀번호 확인</th><td><input type="password" name="mi_pw2" value="<%=mi_pw %>" /><span id="pwmsg"></span></td></tr>
<tr><th>이름</th><td><%=name %></td></tr>
<tr><th>이메일</th><td><input type="text" maxlength="20" size="10" name="mi_em1" value="<%=arrEmail[0] %>"/>@<input size="10" type="text" name="mi_em2" value="<%=arrEmail[1] %>"/></td></tr>

<tr><th>휴대폰</th><td><input type="text" size="3" name="mi_ph1" maxlength="3" value="<%=arrPhone[0] %>"/>-
<input type="text" size="4" maxlength="4" name="mi_ph2" value="<%=arrPhone[1] %>" />-
<input type="text" size="4" maxlength="4" name="mi_ph3" value="<%=arrPhone[2] %>" /></td></tr>
</table>
</div>
<div id="twobtn">
<table width="600" align="center">
<input type="hidden" name="kind" value="<%=kind %>" />
<tr><td colspan="2" align="center">
	<input type="submit" class="btn1" value="<%=caption %>" />
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="button" class="btn1" value="취소" onclick="location.href='/talkbox/tbMain.jsp'" />
</td></tr>
</table>
</div>
</form>
