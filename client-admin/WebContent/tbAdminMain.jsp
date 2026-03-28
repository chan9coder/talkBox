<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="_inc/inc_head.jsp" %>
<%
if(!isLogin) { //  로그인이 되어 있지 않다면
   out.println("<script>");
   out.println("alert('로그인이 필요합니다.'); location.href='index.jsp';");
   out.println("</script>");
   out.close();
}

request.setCharacterEncoding("utf-8");
int cpage = 1, psize = 10, bsize = 10, rcnt = 0, pcnt = 0;
// 페이지   번호  , 페이지 크기,    블록크기   ,레코드(게시글)개수,페이지 개수 등을 저장 할 변수

if(request.getParameter("cpage") != null)
   cpage=Integer.parseInt(request.getParameter("cpage"));

String schtype = request.getParameter("schtype");
String keyword = request.getParameter("keyword");

String schargs = "";
String where = "";


if (schtype == null || schtype.equals("") || keyword == null || keyword.equals("")) {// 검색을 하지 않는 경우
   schtype = ""; keyword = "";
} else {   // 검색을 할 경우
      keyword = getRequest(keyword);
      // 쿼리스트링으로 주고 받는 검색어가 한글일 경우 IE에서 문제가 발생할 수도 있으므로 유니코드로 변환
   
      where += "where  mi_" + schtype + " like '%" + keyword + "%' ";
      
      schargs = "&schtype=" + schtype + "&keyword=" + keyword;
      
      // 검색조건이 있을 경우 링크의 url에 붙일 쿼리스트링 완성
}

try{
   stmt = conn.createStatement();
   //가져올 쿼리 2개(1.목록  2.전체게시글 갯수)
   sql = "select count(*) from t_member_info ";
   //자유게시판 레코드의 개수(검색조건 포함)를 받아 올 쿼리
   rs = stmt.executeQuery(sql);
   if(rs.next())    rcnt = rs.getInt(1);
   
   pcnt = rcnt / psize;  
   if(rcnt % psize > 0)   pcnt++;
   
   //limit의 시작값
   int start = (cpage - 1) * psize;
   //글목록 쿼리
   sql = "select mi_id, mi_name, mi_phone, mi_email, if(mi_status='a','정상회원',if(mi_status='b','휴면회원','탈퇴회원')) status,"+
   " left(mi_date,10) date from t_member_info " + where + " order by mi_id desc limit  " + start + "," + psize;
   System.out.println(sql);
   rs = stmt.executeQuery(sql);
   
} catch(Exception e) {
   out.println("자유게사판 목록에서 문제가 발생했습니다.");
   e.printStackTrace();
}
%>

    
      <div id="right" style="display:inline-block; float:right;">
      <div>
         <form name="frmSch" align="center" style="padding:10px;">
         <select name="schtype">
            <option value="id" <%if(schtype.equals("id")) {%>selected="selected"<% } %>>아이디</option>
            <option value="name" <%if(schtype.equals("name")) {%>selected="selected"<% } %>>이름</option>
            <option value="email" <%if(schtype.equals("email")) {%>selected="selected"<% } %>>이메일</option>
            <option value="phone" <%if(schtype.equals("phone")) {%>selected="selected"<% } %>>전화번호</option>
         </select>      
         <input type="text" name="keyword" value="<%=keyword %>">
         <input type="submit" value="검색">&nbsp;&nbsp;&nbsp;
         <input type="button" value="전체 글 보기" onclick="location.href='tbAdminMemInfo.jsp'">
         </form>
      </div>
   <table width="1300px" border="0" cellpadding="0" cellspacing="0"id="list">
   <tr height="30">
   <th width="10%">번호</th>
   <th width="10%">아이디</th>
   <th width="10%">이름</th>
   <th width="*">이메일</th>
   <th width="20%">전화번호</th>
   <th width="10%">가입일자</th>
   <th width="10%">상태</th>
   </tr>
<%
   if(rs.next()) {
      
      int num = rcnt - (cpage - 1) *psize;
      do{  
   %>
   <tr height="30" align="center">
   <td><%=num %></td>

   <td><%=rs.getString("mi_id")  %></td>
   <td><%=rs.getString("mi_name")  %></td>
   <td><%=rs.getString("mi_email")  %></td>
   <td><%=rs.getString("mi_phone") %></td>
   <td><%=rs.getString("date") %></td>
   <td><%=rs.getString("status") %></td>
   </tr>
   <%   
   num--;
   } while(rs.next());   
}else { //보여줄 게시글이 없을때
   out.println("<tr height='30'><td colspan='7'>검색결과가 없습니다.</td></tr>");
}
%>
</table>
<br>
<table width="1300px" id="list" >
<tr align="center">
<td></td>
<%
if(rcnt > 0){ //게시글이 있으면
    String link ="tbAdminMemInfo.jsp?cpage=";
      if (cpage == 1) {
         out.println("[처음]&nbsp;&nbsp;&nbsp;[이전]&nbsp;&nbsp;");
      } else {
         out.println("<a href='" + link + "1" + schargs + "'>[처음]</a>&nbsp;&nbsp;&nbsp;");
         out.println("<a href='" + link + (cpage - 1) + schargs + "'>[이전]</a>&nbsp;&nbsp;&nbsp;");
      }
      
      int spage = (cpage - 1) / bsize * bsize + 1;      // 블록 시작페이지 번호
      for (int i = 1, j = spage ; i <= bsize && j <= pcnt; i++, j++) {
      // i : 블록에서 보여줄 페이지의 개수만큼 루프를 돌릴 조건으로 사용되는 변수
      // j : 실제 출력할 페이지 번호로 전체 페이지 개수(마지막 페이지 번호)를 넘지 않게 할 변수
         if (j == cpage) {
            out.println("&nbsp;<strong>"+ j + "</strong>&nbsp;");
         } else {
            out.println("&nbsp;<a href='" + link + j + schargs + "'>" + j + "</a>&nbsp;");
         }
      }
      
      if (cpage == pcnt) {
         out.println("&nbsp;&nbsp;[다음]&nbsp;&nbsp;&nbsp;[마지막]");
      } else {
         out.println("&nbsp;&nbsp;<a href='" + link + (cpage + 1) + schargs + "'>[다음]</a>");
         out.println("&nbsp;&nbsp;<a href='" + link + pcnt + schargs + "'>[마지막]</a>");
      }
   }
%>
</tr>

   </table>
   </div>
</div>

<%@ include file="_inc/inc_foot.jsp" %>