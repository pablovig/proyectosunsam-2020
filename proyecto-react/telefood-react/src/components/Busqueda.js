import React, { useEffect, useState } from 'react'
import { Button } from 'primereact/button'
import { InputText } from 'primereact/inputtext'

export const Busqueda = ({busqueda, titulo}) =>{
    const [textoIngresado, setTextoIngresado] = useState('')

    return (
           <div className="p-col-12 p-md-4">
            <div className="p-text-left p-text-bold fontsize p-mb-2">Búsqueda de {titulo}</div>
                <div className="p-inputgroup">
                        <InputText placeholder="Busqueda.." value={textoIngresado} onChange={(event) => setTextoIngresado(event.target.value)} />
                        <Button icon="pi pi-search" className="boton" onClick={() => busqueda(textoIngresado)}/>
                 </div>
            </div>
    )
}