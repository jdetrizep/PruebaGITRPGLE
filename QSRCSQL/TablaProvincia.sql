--====================================================================
-- NOMBRE DE LA TABLA: REGPROV                                       =
-- DESCRIPCIÓN: TABLA CATALOGO DE PROVINCIAS                         =
-- OBJETIVO:                                                         =
--    ALMACENAR EL CATALOGO DE PROVINCIAS                            =
-- USO DE DATOS:                                                     =
--      TABLA DE CATALOGOS                                           =
--====================================================================
-- HECHO POR:                                                        =
--      JORGE DE TRINIDAD ZEPEDA. NOVACOMP S.A.                      =
-- FECHA:                                                            =
--      AGOSTO DE 2022.                                              =
--====================================================================
-- HECHO POR:                                                        =
--                                                                   =
-- FECHA:                                                            =
--                                                                   =
-- DESCRIPCIÓN CAMBIO:                                               =
--                                                                   =
--====================================================================
CREATE TABLE REGPROV (                                                
    CODIGO_PROVINCIA    FOR COLUMN CODPRO CHAR(5) NOT NULL,           
    DESCRIPCION_PROVINCIA FOR COLUMN DESPRO CHAR(50) NOT NULL,        
        CONSTRAINT REGPROV_PK PRIMARY KEY (CODPRO)                    
)RCDFMT REGRPROV;                                                     
                                                                      
RENAME TABLE REGPROV TO REG_PROVINCIA                                 
FOR SYSTEM NAME REGPROV;                                              
                                                                      
LABEL ON TABLE REGPROV IS                                             
           'TABLA DE PROVINCIAS DEL SISTEMA';                         
                                                                      
COMMENT ON TABLE REGPROV IS                  
           'TABLA DE PROVINCIAS DEL SISTEMA';
                                             
LABEL ON COLUMN REGPROV (                    
    CODPRO IS 'CODIGO PROVINCIA',            
    DESPRO IS 'DESCRIPCIÓN PROVINCIA'        
);                                           
                                             
LABEL ON COLUMN REGPROV(                     
    CODPRO TEXT IS 'CODIGO PROVINCIA',       
    DESPRO TEXT IS 'DESCRIPCIÓN PROVINCIA'   
);                                           
                                             
COMMENT ON COLUMN REGPROV(                   
    CODPRO IS 'CODIGO PROVINCIA',            
    DESPRO IS 'DESCRIPCIÓN PROVINCIA'        
);