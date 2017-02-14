classdef GibbsCluster
    properties
        Points
        Length
        Mean
        Sigma
        %Other params like mean variance etc
    end
    
    methods
        function obj= GibbsCluster()
            obj.Points = [];
            obj.Length = 0;
            obj.Mean = [0;0];
            obj.Sigma = zeros(2,2);
        end
        
        function obj = addPoint(obj,point)
            obj.Points = [obj.Points point];
            obj.Length = obj.Length+1;
            obj.Mean = updateMean(obj);
            obj.Sigma = updateSigma(obj);
        end
        
        function [obj,p] = removePoint(obj,point)
            p = obj.Points(:,point);
            obj.Points(:,point)=[];
            obj.Length = max(0,obj.Length-1);
            obj.Mean = updateMean(obj);
            obj.Sigma = updateSigma(obj);
        end
        
        function m = updateMean(obj)
            m = mean(obj.Points,2);
        end
        
        function s = updateSigma(obj)
            if obj.Length==1
                s = eye(2);
            else
                s = (obj.Points-obj.Mean)*(obj.Points-obj.Mean)';
            end
        end
    end
end
