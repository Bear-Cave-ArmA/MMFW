class EGVAR(EndConditions,SleepMenu) {
    displayName = "End Condition Loop Settings";
    collapsed = 0;
    class Attributes {
        class EGVAR(EndConditions,SleepMenuDescription) {
            description = "If end condition var or unit checks do not work at mission start, you can delay them with a condition delay. Condition sleep affects the time between condition checks and can negatively affect performance if it is a complex condition.";
            control = "StructuredText3";
        };
        class EGVAR(EndConditions,ConditionDelay) {
            property = QEGVAR(EndConditions,ConditionDelay);
            displayName = "End Condition Starting Delay";
            tooltip = "Time before any automatic end conditions are run!";
            control = QGVAR(0To5Step1_Slider);
            expression = SCENARIO_EXPRESSION;
            validate = "number";
            defaultValue = "0";
        };
        class EGVAR(EndConditions,ConditionSleep) {
            property = QEGVAR(EndConditions,ConditionSleep);
            displayName = "End Condition Sleep";
            tooltip = "Time between end condition checks. Low values can cause server lag!";
            control = QGVAR(30To100Step1_Slider);
            expression = SCENARIO_EXPRESSION;
            validate = "number";
            defaultValue = "30";
        };
    };
};
