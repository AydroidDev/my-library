<!-- 分页标签By Cowboy -->
<%@tag pageEncoding="UTF-8"%>
<%@ attribute name="page" type="org.springframework.data.domain.Page" required="true"%>
<%@ attribute name="paginationSize" type="java.lang.Integer" required="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
int current =  page.getNumber() + 1;//当前页 
int begin = Math.max(1, current - paginationSize/2);//将当前页放于中间 
int end = Math.min(begin + (paginationSize - 1), page.getTotalPages());
begin = Math.max(1, end-(paginationSize-1));

request.setAttribute("current", current);
request.setAttribute("begin", begin);
request.setAttribute("end", end);
%>


<div class="paging">
		 <% if (page.hasPreviousPage()){%>
                <a href="?page=${current-1}&sortType=${sortType}&${searchParams}">&lt;&lt;</a>
         <%} %>
         <c:choose>
                <c:when test="${begin == 2 }">
                	<a href="?page=1&sortType=${sortType}&${searchParams}">1</a>
                </c:when>
                <c:when test="${begin > 2}">
                	<a href="?page=1&sortType=${sortType}&${searchParams}">1</a>
                	<span class="dots">&hellip;</span>
                </c:when>
                <c:otherwise>
                </c:otherwise>
         </c:choose>
       	 <c:forEach var="i" begin="${begin}" end ="${end}">
        	<c:choose>
	          <c:when test="${i == current}">
	              <span class="current" href="?page=${i}&sortType=${sortType}&${searchParams}">${i}</span>
	          </c:when>
	          <c:otherwise>
	              <a href="?page=${i}&sortType=${sortType}&${searchParams}">${i}</a>
	          </c:otherwise>
         	</c:choose>
       	 </c:forEach>
         <c:choose>
                <c:when test="${end == (page.totalPages-1) }">
                	<a href="?page=${page.totalPages}&sortType=${sortType}&${searchParams}">${page.totalPages}</a>
                </c:when>
                <c:when test="${end < (page.totalPages-1)}">
                	<span class="dots">&hellip;</span>
                	<a href="?page=${page.totalPages}&sortType=${sortType}&${searchParams}">${page.totalPages}</a>
                </c:when>
                <c:otherwise>
                </c:otherwise>
         </c:choose>
         
	  	 <% if (page.hasNextPage()){%>
               	<a href="?page=${current+1}&sortType=${sortType}&${searchParams}">&gt;&gt;</a>
         <%} %>
</div>

