classdef location
    properties(SetAccess= private)
        name
        description
        exits
    end
    methods
        function obj= location(nomIN)
            if (nargin > 0)
                obj.name= nomIN;
            end
        end
    end
    methods
        function nom= get.name(obj)
            nom= obj.name;
        end
        function ex= getExits(obj)
            ex= obj.exits;
        end
    end
end