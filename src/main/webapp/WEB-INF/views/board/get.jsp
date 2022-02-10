<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

   <h1>Get Page</h1>

   <div class="panel-body">

      <div class="form-group">
         <label>Bno</label> <input class="form-control" name='bno'
            value='<c:out value="${board.bno }"/>' readonly="readonly">
      </div>

      <div class="form-group">
         <label>Title</label> <input class="form-control" name='title'
            value='<c:out value="${board.title }"/>' readonly="readonly">
      </div>

      <div class="form-group">
         <label>Text area</label>
         <textarea class="form-control" rows="3" name='content'
            readonly="readonly"><c:out value="${board.content}" /></textarea>
      </div>

      <div class="form-group">
         <label>Writer</label> <input class="form-control" name='writer'
            value='<c:out value="${board.writer }"/>' readonly="readonly">
      </div>

      <button data-oper='modify' class="btn btn-default">
         <a href="/board/modify?bno=<c:out value="${board.bno}"/>">Modify</a>
      </button>
      <button data-oper='list' class="btn btn-info">
         <a href="/board/list">List</a>
      </button>
      
      
      <form id='operForm' action="/boad/modify" method="get">
        <input type='hidden' id='bno' name='bno' value='<c:out value="${board.bno}"/>'>
        <input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
        <input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
        
<%--         <input type='hidden' name='keyword' value='<c:out value="${cri.keyword}"/>'> --%>
<%--         <input type='hidden' name='type' value='<c:out value="${cri.type}"/>'>   --%>
      </form> 
      
   </div>   
</body>
</html>