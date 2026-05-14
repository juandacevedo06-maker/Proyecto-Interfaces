<%-- 
    Document   : misListas
    Created on : 10/05/2026, 4:06:43 p. m.
    Author     : MSI
--%>

<%@ page import="java.util.List" %>
<%@ page import="modelo.Lista" %>
<%@ page import="modelo.ListaDAO" %>
<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%
    if (session.getAttribute("idUsuario") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    int idUsuario = (int) session.getAttribute("idUsuario");
    String nUsuario = (String) session.getAttribute("nUsuario");

    ListaDAO ldao = new ListaDAO();
    List<Lista> listas = ldao.listarPorUsuario(idUsuario);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8"/>
        <title>Mis Listas</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                font-size: 13px;
                background: #fff;
                padding: 20px;
            }
            #header {
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
                margin-top: 10px;
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
            .form-inline {
                display: flex;
                gap: 8px;
                margin-bottom: 15px;
            }
            .form-inline input {
                padding: 5px;
                border: 1px solid #ccc;
                flex: 1;
            }
            .error-msg {
                color: red;
                margin-bottom: 10px;
            }
            .codigo {
                font-family: monospace;
                background: #f5f5f5;
                padding: 2px 6px;
                border: 1px solid #ddd;
            }
        </style>
    </head>
    <body>

        <div id="header">
            <span><strong><%= nUsuario%></strong></span>
            <a href="CerrarSesion" class="btn">Cerrar sesión</a>
        </div>

        <h2>Mis Listas</h2>

        <% if ("1".equals(request.getParameter("error"))) { %>
        <div class="error-msg">Error al crear la lista.</div>
        <% } else if ("2".equals(request.getParameter("error"))) { %>
        <div class="error-msg">Código de lista no encontrado.</div>
        <% } %>

        <%-- Crear lista nueva --%>
        <form method="post" action="CtrolLista" class="form-inline">
            <input type="hidden" name="accion" value="crear"/>
            <input type="text" name="cnombre" placeholder="Nombre de la nueva lista" required/>
            <button type="submit" class="btn">Crear lista</button>
        </form>

        <%-- Unirse por código --%>
        <form method="post" action="CtrolLista" class="form-inline">
            <input type="hidden" name="accion" value="unirse"/>
            <input type="text" name="ccodigo" placeholder="Código de lista compartida" required/>
            <button type="submit" class="btn">Unirse</button>
        </form>

        <table>
            <thead>
                <tr>
                    <th>Lista</th>
                    <th>Código para compartir</th>
                    <th>Acción</th>
                </tr>
            </thead>
            <tbody>
                <% if (listas == null || listas.isEmpty()) { %>
                <tr>
                    <td colspan="3" style="text-align:center;">
                        No tienes listas. ¡Crea una o únete con un código!
                    </td>
                </tr>
                <% } else {
            for (Lista l : listas) {%>
                <tr>
                    <td><%= l.getListaNombre()%></td>
                    <td><span class="codigo"><%= l.getCodigoCompartir()%></span></td>
                    <td>
                        <a href="listaItems.jsp?id=<%= l.getIdLista()%>" class="btn">Ver items</a>
                        &nbsp;
                        <a href="CtrolLista?accion=eliminar&id=<%= l.getIdLista()%>"
                           class="btn btn-danger"
                           onclick="return confirm('¿Eliminar esta lista?')">Eliminar</a>
                    </td>
                </tr>
                <%     }
            }%>
            </tbody>
        </table>

    </body>
</html>