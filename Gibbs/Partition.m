classdef Partition
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Length
        Weight
        Clusters
    end
    
    methods
        function obj= Partition()
            obj.Length = 0;
            obj.Weight = 0;
            obj.Clusters = {};

        end
        
        function obj = addCluster(obj,Cluster)
            obj.Length = obj.Length+1;
            obj.Clusters{obj.Length}=Cluster;
        end
        
        
    end
    
end

