report 62060 "PTE EM CrSR Wizard"
{
    ApplicationArea = All;
    Caption = 'PTE EM CrSR Wizard';
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem(CEMPerDiemGroup; "CEM Per Diem Group")
        {
            RequestFilterFields = Code;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(SubRateQty; SubRateQty)
                    {
                        ApplicationArea = All;
                        Caption = 'Qty. of sub rates to create';
                    }
                    field(StartWithMinimumStayHours; StartWithMinimumStayHours)
                    {
                        ApplicationArea = All;
                        Caption = 'Start with minimum number of hours';
                    }
                    field(DevideBy; DevideBy)
                    {
                        ApplicationArea = All;
                        Caption = 'Meal allowance divisor';
                        ToolTip = 'Defines the integeger divisor that is used for calculation of hourly rate.';
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnPostReport()
    var
        Subrate: Integer;
        PerDiemRateDetails: Record "CEM Per Diem Rate Details v.2";
        PerDiemRate: Record "CEM Per Diem Rate v.2";
    begin
        PerDiemRate.SetRange("Per Diem Group Code", CEMPerDiemGroup.Code);
        if PerDiemRate.FindSet() then begin
            repeat
                if PerDiemRate."First/Last Day Calc. Method" <> PerDiemRate."First/Last Day Calc. Method"::"Sub rates" then begin
                    PerDiemRate.Validate("First/Last Day Calc. Method", PerDiemRate."First/Last Day Calc. Method"::"Sub rates");
                    PerDiemRate.Modify(true);
                end;
                for Subrate := 0 to SubRateQty - 1 do begin
                    Clear(PerDiemRateDetails);
                    PerDiemRateDetails."Per Diem Group Code" := CEMPerDiemGroup.Code;
                    PerDiemRateDetails."Destination Country/Region" := PerDiemRate."Destination Country/Region";
                    PerDiemRateDetails."Accommodation Allowance Code" := PerDiemRate."Accommodation Allowance Code";
                    PerDiemRateDetails."Start Date" := PerDiemRate."Start Date";
                    PerDiemRateDetails."Minimum Stay (hours)" := StartWithMinimumStayHours + Subrate;
                    PerDiemRateDetails."Meal Allowance" := PerDiemRate."Daily Meal Allowance" / DevideBy * (StartWithMinimumStayHours + Subrate + 1);
                    PerDiemRateDetails.Insert(true);
                end;
            until PerDiemRate.Next() = 0;

        end;
    end;

    var
        SubRateQty: Integer;
        StartWithMinimumStayHours: Integer;
        DevideBy: Integer;

}
