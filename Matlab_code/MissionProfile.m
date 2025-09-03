classdef MissionProfile
    properties
        Phases % key
    end
    
    methods
        % function to define an instance of the class 'mission rpofile'
        function obj = MissionProfile(totalPhases, phaseTypes, phaseParams)
            % Validate inputs
            if length(phaseTypes) ~= totalPhases || length(phaseParams) ~= totalPhases
                error('Mismatch between the number of phases, phase types, and phase parameters.');
            end            
            % Initialize each mission phase with its type and parameters
            obj.Phases = cell(1, totalPhases); % initialize cell
            for i = 1:totalPhases
                phaseData.Type = phaseTypes{i};
                phaseData.Parameters = phaseParams{i};
                
                obj.Phases{i} = phaseData; % Store in cell array
            end
        end
        
        % function to display the mission phases
        function list_phases = get_list_phases(obj)
            list_phases = {};
            for i = 1:numel(obj.Phases)
                 list_phases{i} = obj.Phases{i}.Type;
            end
        end
        
        % function to get the parameters of a specific phase by index
        function params = getPhaseParameters(obj, phaseIndex)
            if phaseIndex > 0 && phaseIndex <= numel(obj.Phases)
                params = obj.Phases{phaseIndex}.Parameters; % Access cell array with {}
            else
                error('Invalid phase index.');
            end
        end
        
        % function to get the type of a specific phase by index
        function type = getPhaseType(obj, phaseIndex)
            if phaseIndex > 0 && phaseIndex <= numel(obj.Phases)
                type = obj.Phases{phaseIndex}.Type;
            else
                error('Invalid phase index.');
            end
        end
    end
end
