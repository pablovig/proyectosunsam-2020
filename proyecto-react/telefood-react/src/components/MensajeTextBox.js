import { InputTextarea } from 'primereact/inputtextarea';
import { Button } from 'primereact/button';
import React from 'react'
import { useHistory } from 'react-router-dom';

const actualizar = (funcion)=>(mail)=>(valorLeido) => {
    mail.cuerpoDeMensaje = valorLeido
    funcion(mail)
}

export const MensajeTextBox = (
    {mail, cancelarEnvio, aceptarEnvio, setMensaje}
    ) => {

    return (
        <div className="mens-box">
              <TextAreaBox mensaje={mail} actualizar={actualizar(setMensaje)(mail)} data-testid="textArea"/>     
            <div className="mens-botonblock">
                <BotonesTextBox mail={mail} ejecutarCancelarEnvio={cancelarEnvio} ejecutarAceptarEnvio={aceptarEnvio} data-testid="botones"/>
            </div>                    
        </div>
    )
}

export const BotonesTextBox = ({mail, ejecutarCancelarEnvio, ejecutarAceptarEnvio}) => {
    let history = useHistory()
    const volver = () => { //Se utiliza para Lectura de Mail 
        history.push(`/home`)
    }  
    return (
        mail.esDeLectura()?
        <Button label="Volver" className="p-mx-2  p-mt-2 mens-botonvolver p-button-raised  p-button-sm p-my-3 p-ac-sm-end" onClick={volver} data-testid="botonVolver"></Button>
        :
        <div data-testid="botonesEnEscritura">
            <Button label="Enviar" data-testid="botonAceptar" className="p-mt-2 p-px-3 p-py-2  boton p-button-raised  p-button-sm p-my-3 p-ac-sm-end" onClick={() => ejecutarAceptarEnvio()}></Button>
            <Button label="Cancelar" data-testid="botonCancelar" className="p-mx-2  p-mt-2 mens-botonvolver p-button-raised  p-button-sm p-my-3 p-ac-sm-end" onClick={() => ejecutarCancelarEnvio()}></Button>
        </div>
    )
    
}

export const TextAreaBox = ({mensaje, actualizar}) => {
    return (
        <InputTextarea className="mens-textarea p-m-2" rows={13} cols={43} disabled={mensaje.esDeLectura()} value={mensaje.cuerpoDeMensaje} onChange={(event) => actualizar(event.target.value)}/>
    )
}