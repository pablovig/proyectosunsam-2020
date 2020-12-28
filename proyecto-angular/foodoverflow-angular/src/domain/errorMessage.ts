export function mostrarError(component, error) {
    const errorMessage = (error.status === 0) ? 'Problemas de conexion con backend' : error.error
    component.errors.push(errorMessage)
  }