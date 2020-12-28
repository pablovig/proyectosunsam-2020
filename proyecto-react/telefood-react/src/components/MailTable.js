import React, { useEffect, useState } from 'react'
import { DataTable } from 'primereact/datatable';
import { Column } from 'primereact/column';
import { Button } from 'primereact/button';
import { useHistory } from "react-router-dom";


export const MailTable = ({mails, alCambiarLeido, borrarMail}) =>{

  let history = useHistory();

  return (
    <div className="card pointer">
    <DataTable value={mails} dataKey="id" autoLayout={true} selectionMode="single" onRowDoubleClick={(event) => verMensaje(event, history,alCambiarLeido)} className="p-datatable-sm p-mx-2 " > 
        <Column body={leidoTemplate}></Column>
        <Column body={dateBold} ></Column>
        <Column body={emisorBold}></Column>
        <Column className="end" body={cambiarLeidoTemplate(alCambiarLeido)}></Column>
        <Column className="end" body={borrarMailTemplate(borrarMail)}></Column>
    </DataTable>
</div> 

  )
}

const verMensaje = (event,history, alCambiarLeido) => {
  if(event.data.mensajeLeido == false) alCambiarLeido(event.data)
  history.push(`/mensaje/${event.data.id}`)
}


  const emisorBold = ({ mensajeLeido, emisor }) =>  boldTemplate(mensajeLeido, emisor) 

  const dateBold = ({ mensajeLeido, fechaDeEmision }) => boldTemplate(mensajeLeido, fechaDeEmision) 

  const boldTemplate = (mensajeLeido, elementoAMostrar) => {
    return (
      mensajeLeido ? <span title="Leido" className="noseleccionable">{elementoAMostrar}</span>
        :
    <span title="No leído"  className="p-text-bold noseleccionable" >{elementoAMostrar}</span>
    )
  }
  
  const borrarMailTemplate = (borrarMail) => (mail) => {
    return (
      <Button type="button" icon="pi pi-trash colorletranegra tamañoiconos" className="p-button-rounded p-button-text end" title="Borrar Mail" onClick={() => borrarMail(mail)}></Button>
    )}


  const cambiarLeidoTemplate = (alCambiarLeido) => (mail) => {
    return (
      mail.mensajeLeido ? 
      <Button type="button" icon="pi pi-eye-slash colorletranegra tamañoiconos" className="p-button-rounded p-button-text" title="Marcar como NO leido" onClick={() => alCambiarLeido(mail)}></Button>
      : 
      <Button type="button" icon="pi pi-eye colorletranegra tamañoiconos" className="p-button-rounded p-button-text" title="Marcar como leído" onClick={() => alCambiarLeido(mail)}></Button>
    )
  }

  const leidoTemplate = ({ mensajeLeido }) => {
    return (
      mensajeLeido ? 
        <span title="Leído"  className="noseleccionable" >
              <i className="pi pi-inbox tamañoiconos"></i>
        </span>
  :
        <span title="No leído"  className="noseleccionable" >
            <i className="pi pi-envelope tamañoiconos p-text-bold"></i>
        </span>
    )
  }