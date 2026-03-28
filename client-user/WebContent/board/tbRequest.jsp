<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
if (!isLogin){   // 이미 로그인이 안되어있다면
   out.println("<script>");
   out.println("alert('로그인이 필요한기능입니다.'); location.href='/talkbox/tbLoginForm.jsp' ");
   out.println("</script>");
   out.close();
}
request.setCharacterEncoding("utf-8");

String rc_name = "";
String action = "tbRequestProc.jsp";
String rl_status = "c";

%>
<form name="frm" action=<%=action%> method="post">
<h2 align="center">게시판 요청</h2>
<table align="center">
<tr><th>분류</th><td colspan="3">
<select name="rc_name">
<%
    try{
          stmt = conn.createStatement();
         sql = "select rc_name from t_req_ctgr";
         System.out.println(sql);
         rs = stmt.executeQuery(sql);
         
    if(rs.next()){
      do {
         rc_name = rs.getString("rc_name");
%>
            <option value="<%=rc_name %>"><%=rc_name %></option>
<%      }while(rs.next());
    }
    rs.close();   stmt.close();
 }catch (Exception e) { 
    e.printStackTrace();
}
%>
</select>
</td></tr>
<style>
.clickbtn{background-color:#92d050; color:white;}
</style>
<input type="hidden" name="rl_status" value="<%=rl_status%>">
<tr>
<th>게시판이름</th><td colspan="3"><input type="text" name="rl_name" size="60" /></td>
</tr>
<tr>
<th>용도</th><td colspan="3"><textarea name="rl_use" cols="65" rows="10"></textarea></td>
</tr>
<tr>
<th>회원전용</th><td colspan="3"><input type="radio" name="rl_mem" value="y" checked="checked" />회원
<input type="radio" name="rl_mem" value="n" />비회원</td>
</tr>
<tr>
<th>댓글</th><td colspan="3"><input type="radio" name="rl_isreply" value="y" checked="checked"/>사용
<input type="radio" name="rl_isreply" value="n"/>미사용</td>
</tr>
<tr>
<th></th><td colspan="3"><input type="radio" name="rl_replymem" value="y" checked="checked" />회원
<input type="radio" name="rl_replymem" value="n"/>비회원</td>
</tr>
<tr>
<th></th><td align="right">
<input type="submit" value="요청" onclick="location.href='tbRequestProc.jsp" class="clickbtn"/>
</td>
</tr>
</table>
</form>
<%@ include file="../_inc/inc_foot.jsp" %>