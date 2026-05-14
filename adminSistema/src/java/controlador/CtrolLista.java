package controlador;

import java.io.IOException;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import modelo.Lista;
import modelo.ListaDAO;
import modelo.ListaMiembroDAO;

@WebServlet(name = "CtrolLista", urlPatterns = {"/CtrolLista"})
public class CtrolLista extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String accion = request.getParameter("accion");
        HttpSession sesion = request.getSession(false);

        if (sesion == null || sesion.getAttribute("idUsuario") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int idUsuario = (int) sesion.getAttribute("idUsuario");

        if ("crear".equals(accion)) {
            String nombre = new String(request.getParameter("cnombre").getBytes("ISO-8859-1"), "UTF-8");
            String codigo = UUID.randomUUID().toString().substring(0, 8).toUpperCase();

            Lista l = new Lista();
            l.setFkCreador(idUsuario);
            l.setListaNombre(nombre);
            l.setCodigoCompartir(codigo);

            ListaDAO ldao = new ListaDAO();
            int status = ldao.agregar(l);

            if (status > 0) {
                // también agregamos al creador como miembro
                Lista creada = ldao.buscarPorCodigo(codigo);
                new ListaMiembroDAO().agregar(creada.getIdLista(), idUsuario);
                response.sendRedirect("misListas.jsp");
            } else {
                response.sendRedirect("misListas.jsp?error=1");
            }

        } else if ("unirse".equals(accion)) {
            String codigo = request.getParameter("ccodigo").trim().toUpperCase();
            ListaDAO ldao = new ListaDAO();
            Lista lista = ldao.buscarPorCodigo(codigo);

            if (lista != null) {
                new ListaMiembroDAO().agregar(lista.getIdLista(), idUsuario);
                response.sendRedirect("listaItems.jsp?id=" + lista.getIdLista());
            } else {
                response.sendRedirect("misListas.jsp?error=2");
            }

        } else if ("eliminar".equals(accion)) {
            int idLista = Integer.parseInt(request.getParameter("id"));
            new ListaDAO().eliminar(idLista);
            response.sendRedirect("misListas.jsp");

        } else {
            response.sendRedirect("misListas.jsp");
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