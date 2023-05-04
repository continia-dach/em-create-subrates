// tableextension 62060 "PTE EM CrSR PD Rate Ext" extends "CEM Per Diem Rate v.2"
// {
//     fields
//     {
//         field(62060; "PTE EM CrSR SubRate Qty."; Integer)
//         {
//             Caption = 'PTE EM CrSR SubRate Qty.';
//             FieldClass = FlowField;
//             CalcFormula = count("CEM Per Diem Rate Details v.2" where("Per Diem Group Code" = field("Per Diem Group Code"),
//                     "Destination Country/Region" = field("Destination Country/Region"),
//                     "Accommodation Allowance Code" = field("Accommodation Allowance Code"),
//                     "Start Date" = field("Start Date"))
//             );
//         }
//     }
// }
