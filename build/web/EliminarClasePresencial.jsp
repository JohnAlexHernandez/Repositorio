<%-- 
    Document   : EliminarClasePresencial
    Created on : 12/03/2018, 10:47:47 PM
    Author     : Alex
--%>

<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*" session="true" %>
<%@ page import="modelo.Persona"%>
<%@ page import="modelo.Tutoria"%>
<%@ page import="modelo.Clase"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<!DOCTYPE html>
<%! int i;%>
<%! Persona usu = null;%>
<%! List classList = null;%>
<%! Clase cls = null;%>
<%! HttpSession sesion = null;%>
<%
    sesion = request.getSession();
    if (sesion != null) {
        usu = (Persona) sesion.getAttribute("usuario");
    }
%>

<%  
    sesion = request.getSession();
    if (sesion != null) {
        classList = (ArrayList) sesion.getAttribute("listaClases");
    }
%>

<%
    sesion = request.getSession();
    for (i = 0; i < classList.size(); i++) {
        cls = (Clase) classList.get(i);
        if (cls.getTutoria().getCodigoTutoria() == Integer.parseInt(request.getParameter("CodigoTutoria"))) {
            i = classList.size();
            sesion.setAttribute("codigo", cls.getTutoria().getCodigoTutoria());
        }
    }
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8, width=device-width, initial-scale=1.0">
        <title>Asesorías Académicas</title>
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <link rel="stylesheet" type="text/css" href="fonts.css">
        <script src="http://code.jquery.com/jquery-latest.js"></script>
        <script type="text/javascript">

            /*
             
             La funcion paginaActiva() modifica el color a blanco (#FDFDFD) de la pestaña cargada.
             
             */
            function personalizarElementos() {
                if (document.getElementById("solicitaTuClasePresencial").firstChild.href == window.location.href) {
                    sessionStorage.clear();
                    document.getElementById("solicitaTuClase").style.backgroundColor = "#FDFDFD";
                    document.getElementById("solicitaTuClase").firstChild.style.color = "#1C242A";
                }

                if (!sessionStorage.getItem("submenuActivo") && sessionStorage.getItem("clickPag")) {
                    document.getElementById(sessionStorage.getItem("clickPag")).style.backgroundColor = "#FDFDFD";
                    document.getElementById(sessionStorage.getItem("clickPag")).firstChild.style.color = "#1C242A";
                }
                else if (sessionStorage.getItem("submenuActivo") == "solicitaTuClase") {
                    sessionStorage.clear();
                    document.getElementById("solicitaTuClase").style.backgroundColor = "#FDFDFD";
                    document.getElementById("solicitaTuClase").firstChild.style.color = "#1C242A";
                }

                var date = new Date();
                document.getElementById("fecha").valueAsDate = date;
                document.getElementById("hora").value = date.getHours() + ":" + date.getMinutes();
                document.getElementById("datosEstudiante").style.display = "none";
                document.getElementById("datosClase").style.display = "none";
                
                if ('<%= session.getAttribute("confirmacionFallidaVerClasePresencial")%>' != "" && '<%= session.getAttribute("confirmacionExitosaVerClasePresencial")%>' == "") {
                    document.getElementById("confirmacionFallidaVerClasePresencial").innerHTML = '<%= session.getAttribute("confirmacionFallidaVerClasePresencial")%>';
                    document.getElementById("confirmacionFallidaVerClasePresencial").style.display = "block";
                    document.getElementById("confirmacionExitosaVerClasePresencial").style.display = "none";
                } else if ('<%= session.getAttribute("confirmacionFallidaVerClasePresencial")%>' == "" && '<%= session.getAttribute("confirmacionExitosaVerClasePresencial")%>' != "") {
                    document.getElementById("confirmacionExitosaVerClasePresencial").innerHTML = '<%= session.getAttribute("confirmacionExitosaVerClasePresencial")%>';
                    document.getElementById("confirmacionExitosaVerClasePresencial").style.display = "block";
                    document.getElementById("confirmacionFallidaVerClasePresencial").style.display = "none";
                }
            }

            function anteriorStep(fieldset) {
                var steps = document.getElementsByTagName("fieldset");
                for (var i = 0; i < steps.length; i++) {
                    if (steps[i].id == fieldset) {
                        steps[i].style.display = "none";
                        steps[i - 1].style.display = "block";
                    }
                }
            }

            function siguienteStep(fieldset) {
                var steps = document.getElementsByTagName("fieldset");
                for (var i = 0; i < steps.length; i++) {
                    if (steps[i].id == fieldset) {
                        if (fieldset == "datosClase") {
                            if (document.getElementById("mensaje").value == "") {
                                document.getElementById("mensaje").required = true;
                            }
                            else {
                                steps[i].style.display = "none";
                                steps[i + 1].style.display = "block";
                            }
                        }
                        else if (fieldset == "datosHorario") {
                            if (document.getElementById("duracion").value == "") {
                                document.getElementById("duracion").required = true;
                            }
                            else {
                                steps[i].style.display = "none";
                                steps[i + 1].style.display = "block";
                            }
                        }
                        else {
                            steps[i].style.display = "none";
                            steps[i + 1].style.display = "block";
                        }
                    }
                }
            }

            /*
             
             La funcion validar() verifica los campos del formulario, retorna "false" si algun campo no cumple con las restricciones definidas.
             
             */

            function validar() {
                var campos = document.getElementsByClassName("contformulario");
                for (var i = 0; i < campos.length; i++) {
                    if (!campos[i].checkValidity()) {
                        return false;
                    }
                }
            }

            /*
             
             La funcion establecerElemento(pagina) define el objeto sessionStorage "clickPag" como el id del Nodo padre del elemento sobre el que sea hace click.
             
             */

            function establecerElemento(pagina) {
                sessionStorage.setItem("clickPag", pagina.parentNode.id);
            }

            /*
             
             La funcion establecerElementoSubmenu() define el objeto sessionStorage "submenuActivo" como el id "solicitaTuClase" que contiene los elementos del submenu sobre el que se hace click.
             
             */

            function establecerElementoSubmenu() {
                sessionStorage.setItem("submenuActivo", "solicitaTuClase");
            }
            
            /*
        
            La funcion main crea la animación del menu desplegable y adaptable a dispositivos móviles.

             */    

            $(document).ready(main);
            var contador = 1;

            function main () {
                $('.menu_bar').click(function(){
                        if (contador == 1) {
                                $('nav').animate({
                                        left: '0'
                                });
                                contador = 0;
                        } else {
                                contador = 1;
                                $('nav').animate({
                                        left: '-100%'
                                });
                        }
                });

                $('#solicitaTuClase').click(function(){
                        $(this).children('#l02').slideToggle();
                });
            }
        </script>
    </head>
    <body onload="personalizarElementos()">
        <header>
            <%if (usu != null) {%>
                <a href="logout" class="enlaceLogin" onclick="return confirm('¿Está seguro(a) de cerrar sesión?');">Cerrar sesión</a></br>
                <a href="miCuenta.jsp" class="enlaceLogin">Mi cuenta</a>
            <%} else {%>
                <a href="login.jsp" class="enlaceLogin">Iniciar sesión</a>
            <%}%>
            <a href="index.jsp" id="enlaceBanner">
                <div>
                    <div class="cabecera">
                        <h1>Asesorías Académicas</h1>
                        <h3>Justo lo que necesitabas!</h3>
                    </div>
                    <div class="imgcabecera">
                        <a href="index.jsp"><img src="imagenes/banner.png" alt="banner" id="imagenCabecera"></a>
                    </div>
                </div>
            </a>
        </header>
        <div class="menu_bar">
            <a href="#" class="bt-menu"><span class="icon-menu"></span>Menú</a>
        </div>
        <nav>
            <ul id="l01">
                <li id="index"><a href="index.jsp" onclick="establecerElemento(this)">Inicio</a></li>
                <li id="asignaturas"><a href="asignaturas.jsp" onclick="establecerElemento(this)">Asignaturas</a></li>
                    <%if (usu != null) {%>
                <li id="solicitaTuClase"><a href="#">Solicita tu clase</a>
                    <ul id="l02">
                        <li id="solicitaTuClasePresencial"><a href="solicitaTuClasePresencial.jsp" onclick="establecerElementoSubmenu()">Presencial</a></li>
                        <li id="solicitaTuClaseVirtual"><a href="solicitaTuClaseVirtual.jsp" onclick="establecerElementoSubmenu()">Virtual</a></li>
                    </ul>
                </li>
                <li id="dejanosTuTrabajo"><a href="dejanosTuTrabajo.jsp" onclick="establecerElemento(this)">Dejanos tu trabajo</a></li>
                    <%} else {%>
                <li id="solicitaTuClase"><a href="#">Solicita tu clase</a>
                    <ul id="l02">
                        <li id="solicitaTuClasePresencial"><a href="NuevaClasePresencial.jsp" onclick="establecerElementoSubmenu()">Presencial</a></li>
                        <li id="solicitaTuClaseVirtual"><a href="solicitaTuClaseVirtual.jsp" onclick="establecerElementoSubmenu()">Virtual</a></li>
                    </ul>
                </li>
                <li id="dejanosTuTrabajo"><a href="NuevoTrabajo.jsp" onclick="establecerElemento(this)">Dejanos tu trabajo</a></li>
                    <%}%>
                <li id="contacto"><a href="contacto.jsp" onclick="establecerElemento(this)">Contacto</a></li>
            </ul>
        </nav>

        <section id="contenido">

            <ul class="breadcrumb">
                <li>Usted se encuentra aquí: <a href="solicitaTuClasePresencial.jsp">Solicita tu clase Presencial</a></li>
                <li>Eliminar Clase</li>
            </ul></br>

            <article>
                <p id="confirmacionExitosaEliminarClasePresencial" class="confirmacionExitosa"></p>
                <p id="confirmacionFallidaEliminarClasePresencial" class="confirmacionFallida"></p>
                <p>A continuación usted encontrará en detalle la tutoría de tipo presencial seleccionada:</p>
                <section class="datoformulario">
                    <table id="datos">
                        <tr>
                            <th>Datos clase</th>
                        </tr>
                        <tr>
                            <td>
                                <p id="fecha"><b>Fecha:</b> <%if (cls != null) {%> <%= cls.getFechaClase()%> <%}%></p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p id="fecha" class="contformulario"><b>Hora:</b> <%if (cls != null) {%> <%= cls.getHoraClase()%> <%}%></p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p id="fecha" class="contformulario"><b>Duración(Horas):</b> <%if (cls != null) {%> <%= cls.getDuracionClase()%> <%}%></p>
                            </td>
                        </tr>
                    </table>
                </section>
                <section class="datoformulario">
                    <table id="datos">
                        <tr>
                            <th>Datos Estudiante</th>
                        </tr>
                        <tr>
                            <td>
                                <p id="fecha" class="contformulario"><b>Nombre:</b> <%if (usu != null) {%> <%= usu.getNombrePersona()%> <%}%></p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p id="fecha" class="contformulario"><b>Dirección</b> <%if (usu != null) {%> <%= usu.getDireccionPersona()%> <%}%></p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p id="fecha" class="contformulario"><b>Barrio:</b> <%if (usu != null) {%> <%= usu.getBarrioResidenciaPersona()%> <%}%></p>
                            </td>
                        </tr>   
                        <tr>
                            <td>
                                <p id="fecha" class="contformulario"><b>Teléfono:</b> <%if (usu != null) {%> <%= usu.getTelefonoPersona()%> <%}%></p>
                            </td>
                        </tr>
                    </table>
                </section>
                <section>
                    <table id="datos">
                        <tr>
                            <th>Datos Tutoría</th>
                        </tr>
                        <tr>
                            <td>
                                <p id="fecha" class="contformulario"><b>Materia:</b> <%if (cls != null) {%> <%= cls.getTutoria().getAsignaturaTutoria()%> <%}%></p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p id="fecha" class="contformulario"><b>Tema:</b> <%if (cls != null) {%> <%= cls.getTutoria().getTemaTutoria()%> <%}%></p>
                            </td>
                        </tr>    
                        <tr>
                            <td>
                                <p id="fecha" class="contformulario"><b>Dudas/Inquietudes:</b> <%if (cls != null) {%> <%= cls.getTutoria().getDudasInquietudesTutoria()%> <%}%></p>
                            </td>
                        </tr>
                    </table>
                </section>
                <section class="confirmarformulario">
                    <a href="solicitaTuClasePresencial.jsp"><button type="button" id="btnAtras">Atrás</button></a>
                    <a href="borrarClasePresencial"><button type="button" id="btnEliminarCalse" onclick="return confirm('¿Esta seguro(a) de eliminar la Clase Presencial seleccionada?');">Eliminar Clase</button></a>
                </section>
            </article>
        </section>

        <aside>
            <div class="social">
                <ul>
                    <li><a href="https://www.facebook.com/AsesoriaAcademicaVirtual/" target="_blank" class="icon-facebook"></a></li>
                    <li><a href="https://web.whatsapp.com/send?phone=573137632643&text=" target="_blank" class="icon-whatsapp"></a></li>
                </ul>
            </div>
        </aside>

        <footer>
            <div class="textFooter">
                <p>Copyright &copy; by AsesoriasAcademicas.com</p>
            </div>
        </footer>
    </body>
</html>
