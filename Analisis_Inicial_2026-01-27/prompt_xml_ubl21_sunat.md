# PROMPT COMPLEMENTARIO — GENERACIÓN DE XML UBL 2.1 (SUNAT PERÚ)
## Stack: React + .NET (C#) + PostgreSQL

---

## CONTEXTO

Este prompt complementa el sistema comercial ya en desarrollo. Se necesita implementar la **generación del XML en formato UBL 2.1**, que es el estándar obligatorio que exige SUNAT para todos los comprobantes electrónicos en Perú (Facturas, Boletas, Notas de Crédito y Notas de Débito).

El XML generado debe:
1. Cumplir con el estándar **UBL 2.1** adaptado por SUNAT.
2. Contener **firma digital** (XMLDSig con certificado digital .pfx).
3. Poder enviarse al **Web Service de SUNAT** (OSE o directamente).
4. Guardarse en base de datos y en disco como archivo `.xml` + el CDR (Constancia de Recepción).

---

## NAMESPACES OBLIGATORIOS EN EL XML

Todos los comprobantes deben incluir estos namespaces en el tag raíz:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Invoice
  xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
  xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
  xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
  xmlns:ccts="urn:un:unece:uncefact:documentation:2"
  xmlns:ds="http://www.w3.org/2000/09/xmldsig#"
  xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
  xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2"
  xmlns:sac="urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1"
  xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
```
> Para Boleta se usa el mismo tag `<Invoice>`. Para Nota de Crédito: `<CreditNote>`. Para Nota de Débito: `<DebitNote>`.

---

## ESTRUCTURA XML COMPLETA — FACTURA / BOLETA

### CABECERA DEL DOCUMENTO

```xml
<!-- Firma digital (se completa después de firmar) -->
<ext:UBLExtensions>
  <ext:UBLExtension>
    <ext:ExtensionContent/>
  </ext:UBLExtension>
</ext:UBLExtensions>

<!-- Versión UBL -->
<cbc:UBLVersionID>2.1</cbc:UBLVersionID>

<!-- Versión del esquema SUNAT -->
<cbc:CustomizationID>2.0</cbc:CustomizationID>

<!-- Tipo de operación (Catálogo 51 SUNAT) -->
<!-- 0101 = Venta interna, 0112 = Ticket de Máquina Registradora -->
<cbc:ProfileID>0101</cbc:ProfileID>

<!-- Número del comprobante: SERIE-NUMERO (ej: F001-00000001) -->
<cbc:ID>F001-00000001</cbc:ID>

<!-- Fecha de emisión -->
<cbc:IssueDate>2024-01-15</cbc:IssueDate>

<!-- Hora de emisión -->
<cbc:IssueTime>10:30:00</cbc:IssueTime>

<!-- Fecha de vencimiento (opcional para facturas con crédito) -->
<cbc:DueDate>2024-02-15</cbc:DueDate>

<!-- Tipo de comprobante (Catálogo 01 SUNAT) -->
<!-- 01=Factura, 03=Boleta, 07=Nota Crédito, 08=Nota Débito -->
<cbc:InvoiceTypeCode listID="0101">01</cbc:InvoiceTypeCode>

<!-- Observaciones / leyenda -->
<cbc:Note languageLocaleID="1000">SON QUINIENTOS CON 00/100 SOLES</cbc:Note>

<!-- Moneda (PEN=Soles, USD=Dólares) -->
<cbc:DocumentCurrencyCode>PEN</cbc:DocumentCurrencyCode>

<!-- Número de ítems en el detalle -->
<cbc:LineCountNumeric>2</cbc:LineCountNumeric>
```

---

### DATOS DEL EMISOR (TU EMPRESA)

```xml
<cac:Signature>
  <cbc:ID><!-- RUC de la empresa --></cbc:ID>
  <cac:SignatoryParty>
    <cac:PartyIdentification>
      <cbc:ID>20123456789</cbc:ID>
    </cac:PartyIdentification>
    <cac:PartyName>
      <cbc:Name>MI EMPRESA SAC</cbc:Name>
    </cac:PartyName>
  </cac:SignatoryParty>
  <cac:DigitalSignatureAttachment>
    <cac:ExternalReference>
      <cbc:URI>#SignatureSP</cbc:URI>
    </cac:ExternalReference>
  </cac:DigitalSignatureAttachment>
</cac:Signature>

<cac:AccountingSupplierParty>
  <cbc:CustomerAssignedAccountID>20123456789</cbc:CustomerAssignedAccountID>
  <!-- Catálogo 06: 6=RUC -->
  <cbc:AdditionalAccountID>6</cbc:AdditionalAccountID>
  <cac:Party>
    <cac:PartyName>
      <cbc:Name>MI EMPRESA SAC</cbc:Name>
    </cac:PartyName>
    <cac:PartyLegalEntity>
      <cbc:RegistrationName>MI EMPRESA SOCIEDAD ANONIMA CERRADA</cbc:RegistrationName>
      <cac:RegistrationAddress>
        <cbc:ID>150101</cbc:ID> <!-- Ubigeo -->
        <cbc:AddressTypeCode>0000</cbc:AddressTypeCode>
        <cbc:CitySubdivisionName>URB. LOS PINOS</cbc:CitySubdivisionName>
        <cbc:CityName>LIMA</cbc:CityName>
        <cbc:CountrySubentity>LIMA</cbc:CountrySubentity>
        <cbc:District>MIRAFLORES</cbc:District>
        <cac:AddressLine>
          <cbc:Line>AV. PRINCIPAL 123</cbc:Line>
        </cac:AddressLine>
        <cac:Country>
          <cbc:IdentificationCode>PE</cbc:IdentificationCode>
        </cac:Country>
      </cac:RegistrationAddress>
    </cac:PartyLegalEntity>
  </cac:Party>
</cac:AccountingSupplierParty>
```

---

### DATOS DEL CLIENTE (RECEPTOR)

```xml
<cac:AccountingCustomerParty>
  <!-- Número de documento del cliente -->
  <cbc:CustomerAssignedAccountID>20987654321</cbc:CustomerAssignedAccountID>
  <!-- Catálogo 06: 6=RUC, 1=DNI, 4=Carnet Extranjería, 7=Pasaporte -->
  <cbc:AdditionalAccountID>6</cbc:AdditionalAccountID>
  <cac:Party>
    <cac:PartyLegalEntity>
      <cbc:RegistrationName>CLIENTE SAC</cbc:RegistrationName>
    </cac:PartyLegalEntity>
  </cac:Party>
</cac:AccountingCustomerParty>

<!-- Para Boletas sin datos de cliente (monto < 700 soles): -->
<!--
<cac:AccountingCustomerParty>
  <cbc:CustomerAssignedAccountID>-</cbc:CustomerAssignedAccountID>
  <cbc:AdditionalAccountID>-</cbc:AdditionalAccountID>
  <cac:Party>
    <cac:PartyLegalEntity>
      <cbc:RegistrationName>-</cbc:RegistrationName>
    </cac:PartyLegalEntity>
  </cac:Party>
</cac:AccountingCustomerParty>
-->
```

---

### TOTALES DE IMPUESTOS (NIVEL CABECERA)

```xml
<cac:TaxTotal>
  <!-- Sumatoria total de todos los impuestos -->
  <cbc:TaxAmount currencyID="PEN">90.00</cbc:TaxAmount>

  <!-- IGV (código 1000) -->
  <cac:TaxSubtotal>
    <cbc:TaxableAmount currencyID="PEN">500.00</cbc:TaxableAmount> <!-- Base imponible -->
    <cbc:TaxAmount currencyID="PEN">90.00</cbc:TaxAmount>           <!-- IGV = base * 18% -->
    <cac:TaxCategory>
      <cbc:ID schemeID="UN/ECE 5305"
              schemeName="Tax Category Identifier"
              schemeAgencyName="United Nations Economic Commission for Europe">S</cbc:ID>
      <cbc:Percent>18.00</cbc:Percent>
      <cbc:TaxExemptionReasonCode>10</cbc:TaxExemptionReasonCode> <!-- Catálogo 07: 10=Gravado -->
      <cac:TaxScheme>
        <cbc:ID>1000</cbc:ID>   <!-- 1000=IGV, 2000=ISC, 9999=Otros -->
        <cbc:Name>IGV</cbc:Name>
        <cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>
      </cac:TaxScheme>
    </cac:TaxCategory>
  </cac:TaxSubtotal>

  <!-- ICBPER (Impuesto al consumo bolsas plásticas) si aplica -->
  <!--
  <cac:TaxSubtotal>
    <cbc:TaxableAmount currencyID="PEN">3</cbc:TaxableAmount> (cantidad de bolsas)
    <cbc:TaxAmount currencyID="PEN">0.30</cbc:TaxAmount>       (0.10 por bolsa)
    <cac:TaxCategory>
      <cbc:ID>S</cbc:ID>
      <cac:TaxScheme>
        <cbc:ID>7152</cbc:ID>
        <cbc:Name>ICBPER</cbc:Name>
        <cbc:TaxTypeCode>OTH</cbc:TaxTypeCode>
      </cac:TaxScheme>
    </cac:TaxCategory>
  </cac:TaxSubtotal>
  -->
</cac:TaxTotal>
```

---

### TOTALES MONETARIOS (IMPORTE LEGAL)

```xml
<cac:LegalMonetaryTotal>
  <!-- Suma de valores de venta gravados con IGV (sin IGV) -->
  <cbc:LineExtensionAmount currencyID="PEN">500.00</cbc:LineExtensionAmount>

  <!-- Precio de venta con todos los tributos (total con IGV) -->
  <cbc:TaxInclusiveAmount currencyID="PEN">590.00</cbc:TaxInclusiveAmount>

  <!-- Descuentos globales (si aplica) -->
  <cbc:AllowanceTotalAmount currencyID="PEN">0.00</cbc:AllowanceTotalAmount>

  <!-- Cargos globales (si aplica) -->
  <cbc:ChargeTotalAmount currencyID="PEN">0.00</cbc:ChargeTotalAmount>

  <!-- IMPORTE TOTAL A PAGAR -->
  <cbc:PayableAmount currencyID="PEN">590.00</cbc:PayableAmount>
</cac:LegalMonetaryTotal>
```

---

### LÍNEAS DE DETALLE (Por cada producto/servicio)

```xml
<cac:InvoiceLine>
  <!-- Número de línea (correlativo desde 1) -->
  <cbc:ID>1</cbc:ID>

  <!-- Cantidad vendida -->
  <cbc:InvoicedQuantity unitCode="NIU">2.000</cbc:InvoicedQuantity>
  <!--
    Códigos de unidad de medida (SUNAT Catálogo 03):
    NIU = Unidad (bienes)
    ZZ  = Unidad (servicios)
    KGM = Kilogramo
    LTR = Litro
    MTR = Metro
    BX  = Caja
    GLL = Galón
  -->

  <!-- Valor de venta total de la línea (sin IGV) -->
  <cbc:LineExtensionAmount currencyID="PEN">250.00</cbc:LineExtensionAmount>

  <!-- Precio de venta unitario CON IGV -->
  <cac:Price>
    <cbc:PriceAmount currencyID="PEN">147.50</cbc:PriceAmount>
  </cac:Price>

  <!-- Valor referencial unitario SIN IGV -->
  <cac:PricingReference>
    <cac:AlternativeConditionPrice>
      <cbc:PriceAmount currencyID="PEN">147.50</cbc:PriceAmount>
      <!-- 01=Precio de venta unitario (incluye IGV) -->
      <cbc:PriceTypeCode>01</cbc:PriceTypeCode>
    </cac:AlternativeConditionPrice>
  </cac:PricingReference>

  <!-- IGV de esta línea -->
  <cac:TaxTotal>
    <cbc:TaxAmount currencyID="PEN">45.00</cbc:TaxAmount>
    <cac:TaxSubtotal>
      <cbc:TaxableAmount currencyID="PEN">250.00</cbc:TaxableAmount>
      <cbc:TaxAmount currencyID="PEN">45.00</cbc:TaxAmount>
      <cac:TaxCategory>
        <cbc:ID>S</cbc:ID>
        <cbc:Percent>18.00</cbc:Percent>
        <!-- Catálogo 07 - Tipo afectación IGV:
             10 = Gravado - Operación Onerosa (lo más común)
             20 = Exonerado - Operación Onerosa
             30 = Inafecto - Operación Onerosa
             40 = Exportación -->
        <cbc:TaxExemptionReasonCode>10</cbc:TaxExemptionReasonCode>
        <cac:TaxScheme>
          <cbc:ID>1000</cbc:ID>
          <cbc:Name>IGV</cbc:Name>
          <cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>
        </cac:TaxScheme>
      </cac:TaxCategory>
    </cac:TaxSubtotal>
  </cac:TaxTotal>

  <!-- Descripción del bien o servicio -->
  <cac:Item>
    <cbc:Description>LAPTOP ASUS ROG 16" I7 16GB</cbc:Description>
    <cac:SellersItemIdentification>
      <!-- Código interno del producto -->
      <cbc:ID>PROD-001</cbc:ID>
    </cac:SellersItemIdentification>
  </cac:Item>
</cac:InvoiceLine>
```

---

## ESTRUCTURA XML — NOTA DE CRÉDITO

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CreditNote xmlns="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"
  [mismos namespaces que Invoice]>

  <cbc:UBLVersionID>2.1</cbc:UBLVersionID>
  <cbc:CustomizationID>2.0</cbc:CustomizationID>
  <cbc:ID>FC01-00000001</cbc:ID>  <!-- Serie empieza con F para facturas, B para boletas -->
  <cbc:IssueDate>2024-01-20</cbc:IssueDate>
  <cbc:IssueTime>14:00:00</cbc:IssueTime>
  <cbc:DocumentCurrencyCode>PEN</cbc:DocumentCurrencyCode>

  <!-- Motivo de la Nota de Crédito (Catálogo 09 SUNAT):
       01 = Anulación de la operación
       02 = Anulación por error en el RUC
       03 = Corrección por error en la descripción
       04 = Descuento global
       05 = Descuento por ítem
       06 = Devolución total
       07 = Devolución por ítem
       08 = Bonificación
       09 = Disminución en el valor
       10 = Otros conceptos -->
  <cbc:DiscrepancyResponse>
    <cbc:ReferenceID>F001-00000001</cbc:ReferenceID> <!-- Comprobante que se afecta -->
    <cbc:ResponseCode>01</cbc:ResponseCode>           <!-- Código del motivo -->
    <cbc:Description>ANULACION DE OPERACION</cbc:Description>
  </cbc:DiscrepancyResponse>

  <!-- Referencia al comprobante original -->
  <cac:BillingReference>
    <cac:InvoiceDocumentReference>
      <cbc:ID>F001-00000001</cbc:ID>
      <cbc:DocumentTypeCode>01</cbc:DocumentTypeCode> <!-- 01=Factura, 03=Boleta -->
    </cac:InvoiceDocumentReference>
  </cac:BillingReference>

  <!-- ... misma estructura de emisor, receptor, impuestos, total y líneas que la Factura ... -->

  <!-- Línea de nota de crédito usa <cac:CreditNoteLine> en lugar de <cac:InvoiceLine> -->
  <cac:CreditNoteLine>
    <cbc:ID>1</cbc:ID>
    <cbc:CreditedQuantity unitCode="NIU">2.000</cbc:CreditedQuantity>
    <!-- ...mismos campos de la línea de factura... -->
  </cac:CreditNoteLine>

</CreditNote>
```

---

## CATÁLOGOS SUNAT IMPORTANTES

### Catálogo 01 — Tipo de Documento
| Código | Descripción |
|--------|-------------|
| 01 | Factura |
| 03 | Boleta de Venta |
| 07 | Nota de Crédito |
| 08 | Nota de Débito |
| 09 | Guía de Remisión Remitente |
| 31 | Guía de Remisión Transportista |
| 20 | Comprobante de Retención |
| 40 | Comprobante de Percepción |

### Catálogo 06 — Tipo de Documento de Identidad
| Código | Descripción |
|--------|-------------|
| 0 | DOC.TRIB.NO.DOM.SIN.RUC |
| 1 | DNI |
| 4 | Carnet de Extranjería |
| 6 | RUC |
| 7 | Pasaporte |
| A | Cédula Diplomática |

### Catálogo 07 — Tipo de Afectación IGV
| Código | Descripción | Impacto |
|--------|-------------|---------|
| 10 | Gravado – Operación Onerosa | Base imponible sí, IGV sí |
| 20 | Exonerado – Operación Onerosa | Base imponible sí, IGV = 0 |
| 30 | Inafecto – Operación Onerosa | Base imponible sí, IGV = 0 |
| 40 | Exportación | Sin IGV |

### Catálogo 09 — Código de Motivo (Nota de Crédito)
| Código | Descripción |
|--------|-------------|
| 01 | Anulación de la operación |
| 06 | Devolución total |
| 07 | Devolución por ítem |
| 04 | Descuento global |
| 13 | Ajuste en operación de exportación |

### Catálogo 10 — Código de Motivo (Nota de Débito)
| Código | Descripción |
|--------|-------------|
| 01 | Intereses por mora |
| 02 | Aumento en el valor |
| 03 | Penalidades / otros conceptos |

### Catálogo 51 — Tipo de Operación (ProfileID)
| Código | Descripción |
|--------|-------------|
| 0101 | Venta interna |
| 0110 | Traslados |
| 0112 | Ticket de máquina registradora |
| 0200 | Exportación de bienes |
| 0401 | Ventas no domiciliados que no califican como exportación |

---

## IMPLEMENTACIÓN EN .NET (C#)

### Estructura de servicios recomendada

```
/Services
  /XML
    IXmlGeneratorService.cs       ← Interfaz
    XmlGeneratorService.cs        ← Lógica de generación XML
    XmlSignerService.cs           ← Firma digital con certificado .pfx
    SunatWebService.cs            ← Envío al WS de SUNAT
  /Comprobantes
    ComprobanteFabrica.cs         ← Factory para armar el DTO antes de generar XML
```

### Clase modelo (DTO) para generar el XML

```csharp
public class ComprobanteXmlDto
{
    // Cabecera
    public string TipoComprobante { get; set; }    // "01", "03", "07", "08"
    public string Serie { get; set; }               // "F001", "B001"
    public int Numero { get; set; }                 // Correlativo
    public DateTime FechaEmision { get; set; }
    public string Moneda { get; set; } = "PEN";
    public string TipoOperacion { get; set; } = "0101";

    // Emisor
    public string RucEmisor { get; set; }
    public string RazonSocialEmisor { get; set; }
    public string DireccionEmisor { get; set; }
    public string UbigeoEmisor { get; set; }

    // Receptor
    public string TipoDocReceptor { get; set; }    // Catálogo 06
    public string NumDocReceptor { get; set; }
    public string NombreReceptor { get; set; }

    // Totales
    public decimal TotalGravadas { get; set; }      // Suma bases gravadas
    public decimal TotalExoneradas { get; set; }    // Suma bases exoneradas
    public decimal TotalInafectas { get; set; }     // Suma bases inafectas
    public decimal TotalIgv { get; set; }           // 18% de TotalGravadas
    public decimal TotalVenta { get; set; }         // TotalGravadas + TotalIgv

    // Forma de pago
    public string FormaPago { get; set; } = "Contado"; // "Credito"
    public List<CuotaPagoDto> Cuotas { get; set; }

    // Líneas de detalle
    public List<LineaComprobanteDto> Lineas { get; set; }

    // Solo para notas
    public string ComprobanteAfectadoSerie { get; set; }
    public string ComprobanteAfectadoNumero { get; set; }
    public string CodigoMotivo { get; set; }
    public string DescripcionMotivo { get; set; }
}

public class LineaComprobanteDto
{
    public int NumeroLinea { get; set; }
    public string CodigoProducto { get; set; }
    public string Descripcion { get; set; }
    public string UnidadMedida { get; set; }        // Catálogo 03
    public decimal Cantidad { get; set; }
    public decimal ValorUnitario { get; set; }      // Sin IGV
    public decimal PrecioUnitario { get; set; }     // Con IGV
    public decimal ValorVenta { get; set; }         // Subtotal sin IGV
    public decimal BaseImponible { get; set; }
    public decimal Igv { get; set; }
    public decimal Total { get; set; }
    public string TipoAfectacionIgv { get; set; }  // Catálogo 07: "10", "20", "30"
}
```

---

## TABLA EN BASE DE DATOS PARA GUARDAR EL XML

```sql
CREATE TABLE comprobantes_electronicos (
  id SERIAL PRIMARY KEY,
  comprobante_venta_id INT REFERENCES comprobantes_venta(id),
  tipo_comprobante VARCHAR(10),      -- 01, 03, 07, 08
  serie VARCHAR(10),
  numero VARCHAR(20),
  nombre_archivo VARCHAR(100),       -- RUC-tipo-serie-numero.xml
  xml_firmado TEXT,                  -- XML completo con firma
  hash_cdr VARCHAR(255),             -- Hash del CDR recibido de SUNAT
  cdr_xml TEXT,                      -- Respuesta CDR de SUNAT
  codigo_respuesta VARCHAR(10),      -- 0 = Aceptado
  descripcion_respuesta TEXT,
  estado_sunat VARCHAR(20),          -- ACEPTADO, RECHAZADO, PENDIENTE, ERROR
  fecha_envio TIMESTAMP,
  fecha_respuesta TIMESTAMP,
  intentos_envio INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

## REGLAS IMPORTANTES PARA LA GENERACIÓN

1. **El nombre del archivo XML** debe seguir el formato: `RUC-TipoDoc-Serie-Número.xml`
   Ejemplo: `20123456789-01-F001-00000001.xml`

2. **El ZIP** que se envía a SUNAT debe contener solo el XML firmado con el mismo nombre.
   Ejemplo: `20123456789-01-F001-00000001.zip`

3. **Firma digital obligatoria:** El XML debe firmarse con el certificado digital (.pfx) del emisor antes de enviar. Usar `System.Security.Cryptography.Xml.SignedXml` en .NET.

4. **Redondeo:** Todos los montos en el XML van con **exactamente 2 decimales** (`0.00`). Las cantidades van con hasta 4 decimales.

5. **Texto del monto total en letras** (campo `<cbc:Note languageLocaleID="1000">`): obligatorio, expresar el total en soles con el formato: `SON QUINIENTOS CON 00/100 SOLES`.

6. **El campo `<cbc:LineCountNumeric>`** debe coincidir exactamente con el número de líneas (`<cac:InvoiceLine>`) del detalle.

7. **Operaciones gratuitas** (precio = 0, tipo 15, 16, 17 del catálogo 07): requieren campos adicionales `<cac:AllowanceCharge>` para indicar el valor referencial.

8. **Forma de pago a crédito:** Si la factura es al crédito, agregar:
   ```xml
   <cac:PaymentTerms>
     <cbc:ID>FormaPago</cbc:ID>
     <cbc:PaymentMeansID>Credito</cbc:PaymentMeansID>
     <cbc:Amount currencyID="PEN">590.00</cbc:Amount>
   </cac:PaymentTerms>
   <!-- Una por cuota: -->
   <cac:PaymentTerms>
     <cbc:ID>Cuota001</cbc:ID>
     <cbc:PaymentMeansID>Cuota</cbc:PaymentMeansID>
     <cbc:Amount currencyID="PEN">295.00</cbc:Amount>
     <cbc:PaymentDueDate>2024-02-15</cbc:PaymentDueDate>
   </cac:PaymentTerms>
   ```

---

## ENTREGABLES ESPERADOS

1. **Servicio .NET `XmlGeneratorService`** que reciba un `ComprobanteXmlDto` y retorne el XML como string.
2. **Servicio .NET `XmlSignerService`** que firme el XML con el certificado .pfx configurado.
3. **Endpoint `POST /api/comprobantes/{id}/generar-xml`** que:
   - Toma el comprobante de venta existente en BD
   - Genera el XML UBL 2.1
   - Lo firma digitalmente
   - Lo guarda en la tabla `comprobantes_electronicos`
   - Retorna el XML para descarga
4. **Tabla `comprobantes_electronicos`** con los campos definidos arriba.
5. **Botón en React** que llame al endpoint y permita descargar el XML generado.

> Antes de generar código, analiza las clases y controladores existentes para seguir las convenciones del proyecto.
