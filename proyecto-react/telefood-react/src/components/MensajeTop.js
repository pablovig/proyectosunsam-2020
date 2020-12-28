import { Button } from "primereact/button";
import { useHistory } from "react-router-dom";
import { mailService } from "../services/mailService";


export const MensajeTop = ({ mail }) => {
    const cambiarEstado = async (id) => {
        await mailService.cambiarEstadoLeido(id)
        history.push(`/home`)
    }

    let history = useHistory()
    const borrar = async (mail) => {
        await mailService.delete(mail.id)
        history.push(`/home`)
    }

  return (
    <div className="etiqueta-top p-px-2 p-pt-2 p-pb-0 p-d-flex p-jc-between">
      <div className=" p-text-bold p-px-1 p-pt-2 p-pb-0">
        <div>
          <i className="pi pi-user p-pr-2 tamañoiconos-g "></i>
          <EmisorDestinoTemplate mail={mail} data-testid="textoNombre" />
          {mail.esDeLectura() && (
            <span
              className=" p-px-1 mens-fechahora"
              data-testid="fechaDeMensaje"
            >
              {mail.fechaDeEmision}
            </span>
          )}
        </div>

        <div className="p-pt-3 mens-titulo">Mensaje</div>
      </div>
      {mail.esDeLectura() && (
        <div
          className="p-d-flex p-flex-column p-as-center"
          data-testid="botones"
        >
          <Button
            icon="pi pi-trash tamañoiconos"
            className="boton-top p-button-rounded p-button-text p-px-1 p-button-secondary"
            onClick={() => borrar(mail)}
            data-testid="botonBorrar"
          />
          <IconoLecturaTemplate
            mensaje={mail}
            cambiarEstado={(id) => cambiarEstado(id)}
          />
        </div>
      )}
    </div>
  );
};

export const EmisorDestinoTemplate = ({ mail }) => {
  const texto = mail.esDeLectura()
    ? "De " + mail.emisor
    : "Para " + mail.destinatario.nombreYApellido;
  return <span className=" p-px-1 p-pt-2 mens-emisor">{texto}</span>;
};

export const IconoLecturaTemplate = ({ mensaje,cambiarEstado}) => (
    <Button
    icon={mensaje.esDeLectura()? 'pi pi-eye-slash tamañoiconos' : 'pi pi-eye tamañoiconos'}
      className="boton-top p-button-rounded p-button-text p-px-1 tamañoiconos p-button-secondary"
      onClick={() => cambiarEstado(mensaje.id)}
      data-testid="botonCambiarALeido"
    />
  ) 
