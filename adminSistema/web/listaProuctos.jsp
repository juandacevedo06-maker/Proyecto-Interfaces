<%-- 
    Document   : listaProuctos
    Created on : 10/05/2026, 4:24:42 p. m.
    Author     : MSI
--%>

<%@ page import="java.util.List" %>
<%@ page import="modelo.Producto" %>
<%@ page import="modelo.ProductoDAO" %>
<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%
    ProductoDAO pdao = new ProductoDAO();
    List<Producto> lista = pdao.listarTodos();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8"/>
        <title>Productos</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                font-size: 13px;
                background: #fff;
                padding: 20px;
            }
            .header-container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-bottom: 1px solid #999;
                padding-bottom: 10px;
                margin-bottom: 20px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
            }
            th, td {
                border: 1px solid #999;
                padding: 8px;
                text-align: left;
            }
            th {
                background: #f0f0f0;
            }
            tr:nth-child(even) {
                background: #f9f9f9;
            }
            .btn {
                background: #f0f0f0;
                border: 1px solid #999;
                padding: 5px 10px;
                text-decoration: none;
                color: #000;
            }
            .btn:hover {
                background: #e0e0e0;
            }
            .btn-danger {
                border-color: #c00;
                color: #c00;
            }
            .ok-msg {
                color: green;
                margin-bottom: 10px;
            }
        </style>
    </head>
    <body>

        <div class="header-container">
            <h2>Productos</h2>
            <a href="agregarProducto.jsp" class="btn">+ Nuevo producto</a>
        </div>

        <% if ("1".equals(request.getParameter("ok"))) { %>
        <div class="ok-msg">Producto guardado correctamente.</div>
        <% } %>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Categoría</th>
                    <th>Acción</th>
                </tr>
            </thead>
            <tbody>
                <% if (lista == null || lista.isEmpty()) { %>
                <tr>
                    <td colspan="4" style="text-align:center;">
                        No hay productos registrados.
                    </td>
                </tr>
                <% } else {
            for (Producto p : lista) {%>
                <tr>
                    <td><%= p.getIdProducto()%></td>
                    <td><%= p.getNombre()%></td>
                    <td><%= p.getCategoria()%></td>
                    <td>
                        <a href="CtrolProducto?accion=eliminar&id=<%= p.getIdProducto()%>"
                           class="btn btn-danger"
                           onclick="return confirm('¿Eliminar este producto?')">Eliminar</a>
                    </td>
                </tr>
                <%     }
            }%>
            </tbody>
        </table>

        <p style="margin-top:15px;">
            <a href="misListas.jsp">← Volver a mis listas</a>
        </p>

    </body>
</html>