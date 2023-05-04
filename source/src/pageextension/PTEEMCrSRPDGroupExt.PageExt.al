pageextension 62060 "PTE EM CrSR PD Group Ext" extends "CEM Per Diem Group Card"
{
    actions
    {
        addfirst(processing)
        {
            action(CreateSubRates)
            {
                ApplicationArea = All;
                Caption = 'Create Subrates';
                Image = CreateRating;

                trigger OnAction()
                begin
                    Report.Run(Report::"PTE EM CrSR Wizard", true, false, Rec);
                end;
            }

            action(RemoveSubRates)
            {
                ApplicationArea = All;
                Caption = 'Remove all subrates';
                Image = Delete;

                trigger OnAction()
                var
                    PerDiemRate: Record "CEM Per Diem Rate v.2";
                    PerDiemRateDetails: Record "CEM Per Diem Rate Details v.2";

                begin
                    PerDiemRate.SetRange("Per Diem Group Code", Rec.Code);
                    if PerDiemRate.FindSet() then
                        repeat
                            PerDiemRateDetails.SetRange("Per Diem Group Code", Rec.Code);
                            PerDiemRateDetails.SetRange("Destination Country/Region", PerDiemRate."Destination Country/Region");
                            PerDiemRateDetails.SetRange("Accommodation Allowance Code", PerDiemRate."Accommodation Allowance Code");
                            PerDiemRateDetails.SetRange("Start Date", PerDiemRate."Start Date");
                            PerDiemRateDetails.DeleteAll(true);
                        until PerDiemRate.Next() = 0;
                    Message('All related per diem rates have been deleted');
                end;
            }
        }
    }
}
