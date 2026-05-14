package modelo;

import java.sql.*;

public class ListaMiembroDAO {

    public int agregar(int idLista, int idUsuario) {
        String q = "INSERT IGNORE INTO Tb_Lista_Miembros (fk_Lista, fk_Usuario) VALUES (?,?)";
        try (Connection con = new Conexion().crearConexion();
             PreparedStatement ps = con.prepareStatement(q)) {
            ps.setInt(1, idLista);
            ps.setInt(2, idUsuario);
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al agregar miembro: " + e.getMessage());
            return 0;
        }
    }
}