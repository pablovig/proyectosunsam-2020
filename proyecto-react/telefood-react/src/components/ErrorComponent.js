import { Button } from 'primereact/button';

export const ErrorComponent = ({setError, textoError}) => {
    return (
        <div p-d-flex className="mensajeError p-pl-2 p-py-0 p-mt-2 p-d-flex p-jc-around p-ai-center">
            <i className="pi pi-times-circle tamañoiconos"></i>
            <div >{textoError}</div>
            <Button icon="pi pi-times p-pt-1" className="p-button-rounded p-button-danger p-button-text" onClick={() => setError(null)}/>
        </div>
    )
}