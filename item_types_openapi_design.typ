#import "@preview/touying:0.7.4": *
#import themes.simple: *

#show: simple-theme.with(aspect-ratio: "16-9")

= OB Elements through Item Type composition

== What is an OB Element?

- One datum comprising (up to) six primitives.
  - ```yaml Value```, ```yaml Unit```, ```yaml Decimals```, ```yaml Precision```, ```yaml StartTime```, ```yaml EndTime```
  - E.g., ```yaml ProdName```, ```yaml ProdType```, ```yaml FileFolderURL```.
- Each has an _OpenAPI type_ which is the data type of ```yaml Value```.
  - ```yaml string```, ```yaml number```, ```yaml integer```, ```yaml boolean```, or array of the previous.
- The data type of ```yaml Value``` is determined by:
  - The "Taxonomy Element" of the OB Element.
    - Defines OpenAPI type and the primitives used.
  - The Item Type of the of the OB Element.

== Example OB Element JSON
```json
"ProdName": {
  "allOf": [
    { "$ref": "#/components/schemas/TaxonomyElementString" },
    { "type": "object",
      "description": "...",
      "x-ob-item-type": "StringItemType",
      ...
    }
  ]
}
```

== Example OB Element YAML
```yaml
ProdName:
  allOf:
    - $ref: '#/components/schemas/TaxonomyElementString'
    - type: object
      description: '...'
      x-ob-item-type: StringItemType
      ...
```
In these slides, ```yaml '#/components/schemas/'``` is omitted.

== OB Elements through Item Type composition
- Item Types are OpenAPI schema definitions with primitives as fields.
  - No custom ```yaml x-ob-item-type``` and ```yaml x-ob-item-type-group```.
- Item Types compose OB Elements through ```yaml allOf```.
- Remove the need for ```yaml TaxonomyElement*```.

= Examples

== Basic Item Types
#slide[
```yaml
StringItemType:
  type: object
  properties:
    Value:
      type: string
```
```yaml IntegerItemType``` and ```yaml BooleanItemType``` are defined similarly.
][
```yaml
DecimalItemType:
  type: object
  properties:
    Value:
      type: number
    Decimals:
      type: integer
    Precision:
      type: integer
```
]

// == Basic Array Item Types
// #slide[
// ```yaml
// StringArrayItemType:
//   type: object
//   properties:
//     Value:
//       type: array
//         items: string
// ```
// ```yaml IntegerItemType:``` and ```yaml BooleanItemType:``` are defined similarly.
// ][
// ```yaml
// DecimalArrayItemType:
//   type: object
//   properties:
//     Value:
//       type: array
//         items: number
//     Decimals:
//       type: integer
//     Precision:
//       type: integer
// ```
// ]

== Enumerations from Item Types
```yaml
ProdTypeItemType:
  type: object
  properties:
    Value:
      type: string
      oneOf:
        - const: ProdCell     # ID
          title: Cell         # label
          description: '...'  # description
        ...
```

== ProdType OB Element
```yaml
ProdType:
  description: '...'
  allOf:
    - $ref: StringItemType
    - $ref: ProdTypeItemType
```

== UUID Item Type
```yaml
UUIDItemType:
  type: object
  properties:
    Value:
      type: string
      pattern: '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'
    Unit:
      type: string
      oneOf:
        - const: UUID
```

== Validated OB Element: ProdID
```yaml
ProdID:
  description: '...'
  allOf:
    - $ref: StringItemType
    - $ref: UUIDItemType
```
More ```yaml Value``` validators are possible:
  - https://swagger.io/docs/specification/v3_0/data-models/data-types/

== Item Type Groups are Item Types
#slide[
```yaml
MassItemType:
  type: object
  properties:
    Unit:
      type: string
      oneOf:
        - const: g
          ...
        - const: kg
          ...
        ...
```
][
```yaml
SmallMassItemType:
  allOf:
    - $ref: MassItemType
    - type: object
      properties:
        Unit:
          type: string
          oneOf:
            - const: g
              ...
```
]

== Example Decimal OB Element
```yaml
SmallMass:
  description: '...'
  allOf:
    - $ref: DecimalItemType
    - $ref: SmallMassItemType
```
