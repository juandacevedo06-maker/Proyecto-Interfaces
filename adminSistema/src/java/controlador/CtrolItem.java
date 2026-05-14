package controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import modelo.ListaItem;
import modelo.ListaItemDAO;

@WebServlet(name = "CtrolItem", urlPatterns = {"/CtrolItem"})
public class CtrolItem extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession sesion = request.getSession(false);

        if (sesion == null || sesion.getAttribute("idUsuario") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int    idUsuario = (int) sesion.getAttribute("idUsuario");
        String accion    = request.getParameter("accion");
        String sIdLista  = request.getParameter("idLista");

        // idLista es obligatorio en todas las acciones
        if (sIdLista == null || sIdLista.isEmpty()) {
            response.sendRedirect("misListas.jsp");
            return;
        }

        int idLista = Integer.parseInt(sIdLista);

        if ("agregar".equals(accion)) {

            String sIdProducto = request.getParameter("cidProducto");
            String sCantidad   = request.getParameter("ccantidad");
            String sUnidad     = request.getParameter("cunidad");

            // validar que el usuario haya seleccionado un producto real
            if (sIdProducto == null || sIdProducto.isEmpty()) {
                response.sendRedirect("listaItems.jsp?id=" + idLista + "&error=1");
                return;
            }

            int    idProducto = Integer.parseInt(sIdProducto);
            double cantidad   = Double.parseDouble(sCantidad);
            String unidad     = new String(sUnidad.getBytes("ISO-8859-1"), "UTF-8");

            ListaItem item = new ListaItem();
            item.setFkLista(idLista);
            item.setFkProducto(idProducto);
            item.setFkAgregadoPor(idUsuario);
            item.setCantidad(cantidad);
            item.setUnidad(unidad);
            item.setComprado(false);

            int status = new ListaItemDAO().agregar(item);

            if (status > 0) {
                response.sendRedirect("listaItems.jsp?id=" + idLista + "&ok=1");
            } else {
                response.sendRedirect("listaItems.jsp?id=" + idLista + "&error=1");
            }

        } else if ("marcar".equals(accion)) {

            int idItem = Integer.parseInt(request.getParameter("idItem"));
            new ListaItemDAO().marcarComprado(idItem, idUsuario);
            response.sendRedirect("listaItems.jsp?id=" + idLista);

        } else if ("eliminar".equals(accion)) {

            int idItem = Integer.parseInt(request.getParameter("idItem"));
            new ListaItemDAO().eliminar(idItem);
            response.sendRedirect("listaItems.jsp?id=" + idLista);

        } else {
            response.sendRedirect("listaItems.jsp?id=" + idLista);
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