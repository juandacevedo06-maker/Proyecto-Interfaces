<%-- 
    Document   : agregarProducto
    Created on : 10/05/2026, 4:24:13 p. m.
    Author     : MSI
--%>

<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%
    String volver = request.getParameter("volver");
    if (volver == null) volver = "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>Agregar Producto</title>
    <style>
        body { font-family: Arial, sans-serif; font-size: 13px;
               background: #fff; padding: 20px; }
        .form-container { border: 1px solid #999; padding: 20px;
                          width: 400px; margin: 0 auto; }
        h2 { text-align: center; border-bottom: 1px solid #999;
             padding-bottom: 10px; }
        .form-group { margin-bottom: 12px; }
        label { display: block; margin-bottom: 4px; font-weight: bold; }
        input[type="text"], select {
            width: 100%; padding: 6px; box-sizing: border-box;
            border: 1px solid #ccc; }
        .btn { background: #f0f0f0; border: 1px solid #999; padding: 8px 15px;
               cursor: pointer; width: 100%; font-weight: bold; }
        .btn:hover { background: #e0e0e0; }
        .error-msg { color: red; text-align: center; margin-bottom: 10px; }
        .link-volver { text-align: center; margin-top: 10px; }
    </style>
</head>
<body>
<div class="form-container">
    <h2>Agregar Producto</h2>

    <% if ("1".equals(request.getParameter("error"))) { %>
        <div class="error-msg">Error al guardar. Intente de nuevo.</div>
    <% } %>

    <form method="post" action="CtrolProducto">
        <input type="hidden" name="accion" value="agregar"/>
        <%-- si venimos de una lista, el controlador nos devuelve a ella --%>
        <input type="hidden" name="volver" value="<%= volver %>"/>

        <div class="form-group">
            <label>Nombre del producto:</label>
            <input type="text" name="cnombre" placeholder="Ej: Leche entera" required/>
        </div>

        <div class="form-group">
            <label>Categoría:</label>
            <select name="ccategoria" required>
                <option value="">Seleccione...</option>
                <option value="Lácteos">Lácteos</option>
                <option value="Panadería">Panadería</option>
                <option value="Carnes">Carnes</option>
                <option value="Verduras">Verduras</option>
                <option value="Frutas">Frutas</option>
                <option value="Granos">Granos</option>
                <option value="Bebidas">Bebidas</option>
                <option value="Despensa">Despensa</option>
                <option value="Otros">Otros</option>
            </select>
        </div>

        <button type="submit" class="btn">Guardar Producto</button>
    </form>

    <div class="link-volver">
        <% if (!volver.isEmpty()) { %>
            <a href="listaItems.jsp?id=<%= volver %>">← Volver a la lista</a>
        <% } else { %>
            <a href="listaProductos.jsp">Ver todos los productos</a>
        <% } %>
    </div>
</div>
</body>
</html>