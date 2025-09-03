classdef AdditionalConstraints
    properties
        Constraint % key
    end
    
    methods
        % function to define an instance of the class 'mission rpofile'
        function obj = AdditionalConstraints(totalConstraints, constraintTypes, constraintParams)
            % Validate inputs
            if length(constraintTypes) ~= totalConstraints || length(constraintParams) ~= totalConstraints
                error('Mismatch between the number of phases, phase types, and phase parameters.');
            end            
            % Initialize each mission phase with its type and parameters
            obj.Constraint = cell(1, totalConstraints); % initialize cell
            for i = 1:totalConstraints
                constraintData.Type = constraintTypes{i};
                constraintData.Parameters = constraintParams{i};
                
                obj.Constraint{i} = constraintData; % Store in cell array
            end
        end
        
        % function to display the mission phases
        function list_constraint = get_list_constraint(obj)
            list_constraint = {};
            for i = 1:numel(obj.Constraint)
                 list_constraint{i} = obj.Constraint{i}.Type;
            end
        end
        
        % function to get the parameters of a specific phase by index
        function params = getConstraintParameters(obj, constraintIndex)
            if constraintIndex > 0 && constraintIndex <= numel(obj.Constraint)
                params = obj.Constraint{constraintIndex}.Parameters; % Access cell array with {}
            else
                error('Invalid phase index.');
            end
        end
        
        % function to get the type of a specific phase by index
        function type = getConstraintType(obj, constraintIndex)
            if constraintIndex > 0 && constraintIndex <= numel(obj.Constraint)
                type = obj.Constraint{constraintIndex}.Type;
            else
                error('Invalid phase index.');
            end
        end
    end
end
