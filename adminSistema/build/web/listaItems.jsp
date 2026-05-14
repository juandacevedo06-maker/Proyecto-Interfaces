<%-- 
    Document   : listaItems
    Created on : 10/05/2026, 4:07:08 p. m.
    Author     : MSI
--%>
<%@ page import="java.util.List" %>
<%@ page import="modelo.ListaItem" %>
<%@ page import="modelo.ListaItemDAO" %>
<%@ page import="modelo.Lista" %>
<%@ page import="modelo.ListaDAO" %>
<%@ page import="modelo.Producto" %>
<%@ page import="modelo.ProductoDAO" %>
<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%
    if (session.getAttribute("idUsuario") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    int idUsuario = (int) session.getAttribute("idUsuario");
    int idLista = Integer.parseInt(request.getParameter("id"));

    ListaDAO ldao = new ListaDAO();
    Lista lista = ldao.buscarPorId(idLista);

    ListaItemDAO itemDAO = new ListaItemDAO();
    List<ListaItem> items = itemDAO.listarPorLista(idLista);

    ProductoDAO pdao = new ProductoDAO();
    List<Producto> productos = pdao.listarTodos();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8"/>
        <title><%= lista != null ? lista.getListaNombre() : "Lista"%></title>
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
            .comprado td {
                color: #999;
                text-decoration: line-through;
            }
            .btn {
                background: #f0f0f0;
                border: 1px solid #999;
                padding: 4px 8px;
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
            .btn-ok     {
                border-color: #090;
                color: #090;
            }
            .form-agregar {
                border: 1px solid #999;
                padding: 15px;
                margin-bottom: 20px;
            }
            .form-agregar h3 {
                margin: 0 0 12px 0;
            }
            table.form-table {
                border: none;
                margin: 0;
            }
            table.form-table td {
                border: none;
                padding: 4px 8px 4px 0;
            }
            table.form-table select,
            table.form-table input[type="number"],
            table.form-table input[type="text"] {
                padding: 5px;
                border: 1px solid #ccc;
                width: 100%;
            }
            .error-msg {
                color: red;
                margin-bottom: 10px;
            }
            .ok-msg    {
                color: green;
                margin-bottom: 10px;
            }
            .codigo {
                font-family: monospace;
                background: #f5f5f5;
                padding: 2px 6px;
                border: 1px solid #ddd;
            }
            .link-nuevo-producto {
                font-size: 12px;
                margin-top: 8px;
            }
        </style>
    </head>
    <body>

        <div id="header">
            <span>
                <a href="misListas.jsp">← Mis listas</a>
                &nbsp;|&nbsp;
                <strong><%= lista != null ? lista.getListaNombre() : ""%></strong>
                &nbsp;— Código:
                <span class="codigo"><%= lista != null ? lista.getCodigoCompartir() : ""%></span>
            </span>
            <a href="CerrarSesion" class="btn">Cerrar sesión</a>
        </div>

        <% if ("1".equals(request.getParameter("error"))) { %>
        <div class="error-msg">Error al agregar el producto. Intente de nuevo.</div>
        <% } %>
        <% if ("1".equals(request.getParameter("ok"))) { %>
        <div class="ok-msg">Producto agregado correctamente.</div>
        <% } %>

        <%-- Formulario agregar item --%>
        <div class="form-agregar">
            <h3>Agregar producto a la lista</h3>

            <% if (productos == null || productos.isEmpty()) { %>
            <p style="color:#c00;">
                No hay productos en el catálogo.
                <a href="agregarProducto.jsp">Crear un producto nuevo</a>
            </p>
            <% } else {%>
            <form method="post" action="CtrolItem">
                <input type="hidden" name="accion"  value="agregar"/>
                <input type="hidden" name="idLista" value="<%= idLista%>"/>

                <table class="form-table">
                    <tr>
                        <td><label>Producto:</label></td>
                        <td><label>Cantidad:</label></td>
                        <td><label>Unidad:</label></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td style="width:220px;">
                            <select name="cidProducto" required>
                                <option value="">Seleccione...</option>
                                <%
                                    String categoriaActual = "";
                                    for (Producto p : productos) {
                                        // separador por categoría
                                        if (!p.getCategoria().equals(categoriaActual)) {
                                            categoriaActual = p.getCategoria();
                                %>
                                <option value="" disabled>── <%= categoriaActual%> ──</option>
                                <%      }%>
                                <option value="<%= p.getIdProducto()%>">
                                    <%= p.getNombre()%>
                                </option>
                                <%  }%>
                            </select>
                        </td>
                        <td style="width:90px;">
                            <input type="number" name="ccantidad" value="1"
                                   min="0.1" step="0.1" required/>
                        </td>
                        <td style="width:90px;">
                            <input type="text" name="cunidad" value="unidad" required/>
                        </td>
                        <td>
                            <button type="submit" class="btn">Agregar</button>
                        </td>
                    </tr>
                </table>
            </form>

            <div class="link-nuevo-producto">
                ¿No encuentras el producto?
                <a href="agregarProducto.jsp?volver=<%= idLista%>">Crear producto nuevo</a>
            </div>
            <% } %>
        </div>

        <%-- Tabla de items --%>
        <table>
            <thead>
                <tr>
                    <th>Producto</th>
                    <th>Cantidad</th>
                    <th>Unidad</th>
                    <th>Agregado por</th>
                    <th>Estado</th>
                    <th>Acción</th>
                </tr>
            </thead>
            <tbody>
                <% if (items == null || items.isEmpty()) { %>
                <tr>
                    <td colspan="6" style="text-align:center;">
                        La lista está vacía. ¡Agrega el primer producto!
                    </td>
                </tr>
                <% } else {
            for (ListaItem item : items) {%>
                <tr class="<%= item.isComprado() ? "comprado" : ""%>">
                    <td><%= item.getNombreProducto()%></td>
                    <td><%= item.getCantidad()%></td>
                    <td><%= item.getUnidad()%></td>
                    <td><%= item.getNombreAgregadoPor()%></td>
                    <td><%= item.isComprado() ? "✔ Comprado" : "Pendiente"%></td>
                    <td>
                        <% if (!item.isComprado()) {%>
                        <a href="CtrolItem?accion=marcar&idLista=<%= idLista%>&idItem=<%= item.getIdItem()%>"
                           class="btn btn-ok">Marcar</a>
                        &nbsp;
                        <% }%>
                        <a href="CtrolItem?accion=eliminar&idLista=<%= idLista%>&idItem=<%= item.getIdItem()%>"
                           class="btn btn-danger"
                           onclick="return confirm('¿Quitar este producto?')">Quitar</a>
                    </td>
                </tr>
                <%     }
            }%>
            </tbody>
        </table>

    </body>
</html>