package controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.Producto;
import modelo.ProductoDAO;

@WebServlet(name = "CtrolProducto", urlPatterns = {"/CtrolProducto"})
public class CtrolProducto extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String accion = request.getParameter("accion");

        if ("agregar".equals(accion)) {
            String nombre = new String(request.getParameter("cnombre").getBytes("ISO-8859-1"), "UTF-8");
            String categoria = new String(request.getParameter("ccategoria").getBytes("ISO-8859-1"), "UTF-8");
            String volver = request.getParameter("volver");

            Producto p = new Producto();
            p.setNombre(nombre);
            p.setCategoria(categoria);

            int status = new ProductoDAO().agregar(p);

            if (status > 0) {
                // si venimos de una lista, volvemos a ella
                if (volver != null && !volver.isEmpty()) {
                    response.sendRedirect("listaItems.jsp?id=" + volver + "&ok=1");
                } else {
                    response.sendRedirect("listaProductos.jsp?ok=1");
                }
            } else {
                response.sendRedirect("agregarProducto.jsp?error=1&volver=" + (volver != null ? volver : ""));
            }

        } else if ("eliminar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            new ProductoDAO().eliminar(id);
            response.sendRedirect("listaProductos.jsp");

        } else {
            response.sendRedirect("listaProductos.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
