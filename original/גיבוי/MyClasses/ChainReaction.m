function obj = ChainReaction(isFree,curLeaf)
    if (isFree)
        obj.create(curLeaf);
        for othrLeaf = 1:1:obj.graphMatrix.vertexes
            if (obj.graphMatrix.adjacentMatrix(curLeaf, othrLeaf) == 1)
                %Check if this other leaf was also freed: (how? column <= 0)
                isFree = true;
                for row = 1:1:obj.graphMatrix.vertexes
                    if (obj.dynamicMatrix(row, othrLeaf) > 0)
                        isFree = false;
                        break;
                    end
                end
                ChainReaction(isFree,othrLeaf);
            end
        end
    end
end
