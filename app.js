//Importación de módulos
const express = require('express'); //Módulo para crear aplicaciones web.
const bodyParser = require('body-parser'); //Módulo para analizar el cuerpo de las solicitudes HTTP
const mysql = require('mysql2/promise'); //Módulo para conectarse a una base de datos MySQL y ejecutar consultas con promesas
const app = express();
const sesision = require ('express-session'); //Módulo para manejar sesiones de usuario.
const path=require('path');
const { connect } = require('http2');

// Configurar middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static(__dirname));
app.use(sesision({
 secret:'Hola',  //CADENA SECRETA , PARA FIRMAR GUARDAR EL ID DE LAS COOKIES DE LA SESION; UNICA
 resave: false, //VOLVER A GUARDAR O PEDIR LAS COOKIES
 saveUninitialized:false  //SABER UNA SESION VACIA 
}))
app.use(express.static(path.join(__dirname))) 
//Creacion de la conexion a la base de datos y se volvio un objeto
const db = ({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'unman'
  });
  app.post('/crear', async (req,res)=>{
    const { Nombre, Tipo, Documento, id_manzanas} = req.body; 
    try{
    //Verificador de usuario
    const conect=await mysql.createConnection(db)
    const [indicador]=await conect.execute('SELECT * FROM usuario WHERE Documento=? AND Tipo=?',[Documento,Tipo]);
    if(indicador.length>0){
      res.status(409).send(`
      <script>
      window.onload = function(){
        alert("Este Usuario Ya Existe");
        window.location.href = '/Ingreso.html';
      }
    </script>
      `)
    }
    else{
    await conect.execute('INSERT INTO usuario (Nombre, Tipo,Documento, id_manzanas) VALUES (?, ?,?,?)',
    [Nombre, Tipo,Documento, id_manzanas])
    res.status(201).send(`
    <script>
      window.onload = function(){
        alert("Datos Guardados :3");
        window.location.href = '/inicio.html'; 
      }
    </script>
    `)}
    await conect.end()
    }
    catch(error){
        console.error('Error en el servidor:', error);
        res.status(500).send(`
        <script>
          window.onload = function(){
            alert("Error En El Envío... :c");
            window.location.href = '/Ingreso.html';
          }
        </script>
        `)
        
    }
})
//Ruta para manejar Login
app.post('/inicia', async(req,res)=>{
  const {Tipo,Documento}= req.body
  try{
    //Verifique las credenciales
    const conect=await mysql.createConnection(db) //reemplazar el db.query por conect.execute
    const [indicador]=await conect.execute('SELECT * FROM usuario WHERE Documento=? AND Tipo=?',[Documento,Tipo]);
    console.log(indicador);
    if(indicador.length>0){
      req.session.usuario=indicador[0].Nombre
      req.session.Documento=Documento
      if(indicador[0].Rol=="administrador"){
        res.locals.usuario=usuario
      res.sendfile(path.join(__dirname,'/administrador.html'))
      }
      else{
        const usuario={nombre:indicador[0].Nombre}
        console.log(usuario)
        res.locals.usuario=usuario
      res.sendfile(path.join(__dirname,'usuario.html'))
    }
    }
    else{
      res.status(401).send("Usuario No Encontrado")
    }
    await conect.end()
  }
  
  catch(error){
    console.error("Error En El Servidor",error);
    res.status(500).send(`

    <script>
      window.onload = function(){
        alert("Error En El Servidor :c");
        window.location.href = '/inicio.html';
      }
    </script>
    `)
  }
  
})

app.post('/obtener-usuario',(req,res)=>{
  const usuario =req.session.usuario;
  if(usuario){
    res.json({nombre: usuario})
  }
  else{
    console.error('error al obtener el usuario')
  }
})


app.post('/obtener-servicios-usuario',async(req,res)=>{
  const usuario=req.session.usuario;
  const Documento=req.session.Documento;
  console.log(usuario,Documento)
  try{
  const conect= await mysql.createConnection(db)
  const [serviciosData]= await conect.execute('SELECT servicios.Nombre FROM usuario INNER JOIN manzanas ON usuario.id_manzanas= manzanas.id_manzanas INNER JOIN manzana_servicios ON manzanas.id_manzanas= manzana_servicios.id_m INNER JOIN servicios ON manzana_servicios.id_s=servicios.id_servicios WHERE usuario.Nombre=?',[usuario]);
  console.log(serviciosData);
  res.json({servicios: serviciosData.map(row=>row.Nombre)})
  await conect.end()
  }
  catch(error){
         console.error('Error En El Servidor:',error);
        res.status(500).send('Error En El Servidor.. :c');
  }
})
app.post('/guardar-servicios-usuario',async(req,res)=>{
  const usuario=req.session.usuario;
  const Documento=req.session.Documento;
  const {servicios,fechaHora}=req.body;
  try{
    const conect= await mysql.createConnection(db)
    const [IDS] = await conect.query('SELECT servicios.id_servicios from servicios where servicios.`Nombre`=?',[servicios]);
    const [IDU] =await conect.execute('SELECT usuario.id_user FROM usuario WHERE usuario.`Documento`=?',[Documento]);
    console.log(IDU[0].id_user, IDU)
    await conect.query(' INSERT INTO solicitudes (fecha, id1, codigoS) VALUES (?,?,?)', [fechaHora, IDU[0].id_user,IDS[0].id_servicios]);
    res.status(200).send('servicios guardados')
    await conect.end()
  }
  catch(error){
    console.error('Error En El Servidor:',error);
   res.status(500).send('Error En El Servidor.. :c');
}
})
app.post('/obtener-servicios-guardados',async(req,res)=>{
  const Documento=req.session.Documento;
  try{
    const conect= await mysql.createConnection(db)
    const [IDU] =await conect.execute('SELECT usuario.id_user FROM usuario WHERE usuario.Documento=?',[Documento]);
    const [serviciosGuardadosData] =await conect.query('SELECT usuario.Nombre, servicios.Nombre, solicitudes.id_solicitudes, solicitudes.fecha FROM solicitudes INNER JOIN usuario ON solicitudes.id1= usuario.id_user  INNER JOIN manzanas ON usuario.id_manzanas = manzanas.id_manzanas  INNER JOIN manzana_servicios ON manzanas.id_manzanas = manzana_servicios.id_m  INNER JOIN servicios ON servicios.id_servicios = manzana_servicios.id_s WHERE  servicios.id_servicios=solicitudes.codigoS AND usuario.Documento=1234',[IDU[0].id_user])
    const serviciosGuardadosFiltrados=serviciosGuardadosData.map(servicio=>({
      Nombre: servicio.Nombre,
      fecha: servicio.fecha,
      id: servicio.id_solicitudes
    }))
    
    res.json({serviciosGuardados: serviciosGuardadosFiltrados})
    await conect.end()
  }
  catch(error){
    console.error('Error En El Servidor:',error);
   res.status(500).send('Error En El Servidor.. :c');
}
})
//eliminar los servicios
app.delete('/eliminar-servicio/:id',async(req,res)=>{
const IdS=req.params.id
console.log(IdS,"aksdjask")
try{
  const conect= await mysql.createConnection(db)
  await conect.execute('DELETE FROM solicitudes WHERE solicitudes.id_solicitudes = ?',[IdS])
  res.status(200).send("Borrado")
  await conect.end();
}
catch(error){
  console.error('Error En El Servidor:',error);
 res.status(500).send('Error En El Servidor.. :c');
}
})
//ruta para cerrar sesion
app.post('/cerrar-sesion',(req,res)=>{
  req.session.destroy((err)=>{
    if(err){
      console.error('error al cerrar sesion',err);
      res.status(500).send("error al cerrar la sesion")
    }
    else{
      res.status(200).send("sesion cerradaaa")
    }
  })
})

app.listen(3000, () => {
    console.log(`Servidor Node.js escuchando `);
  })