/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Conexión;

import java.sql.Statement;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.swing.JOptionPane;

/**
 *
 * @author Alberto Arroyo
 */
public class Conexión {
    private final String USUARIO = "buen_sabor";
    private final String CONTRASEÑA = "1234";
    private final String URLCONEXION = "jdbc:sqlserver://DESKTOP-STBFGEG\\MSSQL:1433;databaseName=PROYECTO_BUENSABOR;encrypt=true;trustServerCertificate=true;";
    private Connection conexion;
    Statement stm;
    ResultSet rs;
    
    public Connection getConexion() throws SQLException{
        try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver"); 
        conexion = DriverManager.getConnection(URLCONEXION, USUARIO, CONTRASEÑA);
        } catch (ClassNotFoundException c) {
            System.out.println("Error al conectarse a la base de datos " + c);
        }
    return conexion;
    }
    
    public ArrayList<String> sacarCampos(String tabla) throws SQLException {
            ArrayList<String> tablas = new ArrayList<>();
            Connection conn = getConexion();
            DatabaseMetaData meta = conn.getMetaData();
            ResultSet sacarTablas = meta.getColumns(null, null, tabla, null);
            while (sacarTablas.next()) {
                tablas.add(sacarTablas.getString("COLUMN_NAME"));
                }
            return tablas;
    }
    
    public String[] sacarRegistros(String query, Connection conexion, String columna) throws SQLException {
        ArrayList<String> registros = new ArrayList<>();
        stm = conexion.createStatement();
        rs = stm.executeQuery(query);
        
        while(rs.next()){
            registros.add(rs.getString(columna));
        }
        String[] registros_trans = registros.toArray(new String[0]);
        return registros_trans;
    }
    
    public void crearRegistros(Connection conexion, String tabla, int cantidad, String[] datos, String[] columnas) throws SQLException{
        String id = ""; int filasAfectadas=0;
        stm = conexion.createStatement();
        conexion.setAutoCommit(false);
        StringBuilder n_preg = new StringBuilder("INSERT INTO " + tabla + " VALUES(");
        for (int i = 1; i <= cantidad - 1; i++) {
            n_preg.append("?, ");
        }
        n_preg.append("?)");
        String query = n_preg.toString();

        try (PreparedStatement pst = conexion.prepareStatement(query)) {
            for (int i = 0; i < cantidad; i++) {
                String tabla_comp = columnas[i];

                if (!(tabla_comp.equalsIgnoreCase("EDAD"))) {
                    try {
                        double valor_dou = Double.parseDouble(datos[i]);
                        pst.setDouble(i + 1, valor_dou);
                    } catch (NumberFormatException e) {
                        pst.setString(i + 1, datos[i]);
                    }
                } else {
                    int valor_ent = Integer.parseInt(datos[i]);
                    pst.setInt(i + 1, valor_ent);
                }
            }
            filasAfectadas = pst.executeUpdate();
        }
        System.out.println("Filas insertadas: " + filasAfectadas);
        conexion.commit();
    }
    
    public void updStatement(String query, Connection conexion) throws SQLException{
        String id = "";
        stm = conexion.createStatement();
        conexion.setAutoCommit(false);
        if (conexion != null) {
            try {
                int rowsAffected = stm.executeUpdate(query);
                conexion.commit();
                JOptionPane.showMessageDialog(null, "Filas afectadas: " + rowsAffected);
            } catch (SQLException e) {
                if (e.getErrorCode() == 547) {
                    JOptionPane.showMessageDialog(null, "Error: No se puede eliminar este registro porque está vinculado a una clave primaria en otra tabla.");
                } else {
                    JOptionPane.showMessageDialog(null, "Error de SQL: " + e.getMessage());
                }
        }
            }
    }
    
    public String busquedaRapida(String query, Connection conexion, String tabla) throws SQLException{
        String id = "";
        stm = conexion.createStatement();
        rs = stm.executeQuery(query);
        while(rs.next()){
            id = rs.getString(tabla);
        }
        
        return id;
    }
    
    public ArrayList<Object[]> ejecutaStatement(String query, Connection conexion, String... columnas) throws SQLException {
        ArrayList<Object[]> registros = new ArrayList<>();
        try {
            stm = conexion.createStatement();
            rs = stm.executeQuery(query);
            
            while (rs.next()) {
                    String[] fila = new String[columnas.length];
                    for (int i = 0; i < columnas.length; i++) {
                        fila[i] = rs.getString(i + 1);
                    }
                    registros.add(fila);
                }
            return registros;
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null,"Error: " + e);
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    JOptionPane.showMessageDialog(null,"Error: " + e);
                }
            }
            if (stm != null) {
                try {
                    stm.close();
                } catch (SQLException e) {
                    JOptionPane.showMessageDialog(null,"Error: " + e);
                }
            }
            if (conexion != null) {
                try {
                    conexion.close();
                } catch (SQLException e) {
                    JOptionPane.showMessageDialog(null,"Error: " + e);
                }
            }
        }
        return null;
    }
}
