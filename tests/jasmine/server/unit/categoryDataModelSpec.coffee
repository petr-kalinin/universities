describe "Category", ->
    it "should be created with name and parent", ->
        spyOn Categories.collection, "insert"
            .and.returnValue true

        Categories.create "Category 1", "foo"
 
        expect(Categories.collection.insert).toHaveBeenCalledWith
            name: "Category 1",
            parent: "foo"
                
    it "should be possible to find root and top-level categories", ->
        spyOn Categories.collection, "findOne"
            .and.returnValue _id: "000"
        spyOn Categories.collection, "find"
            .and.returnValue _id: "111"
                
        a = Categories.findRoot()
        b = Categories.findTopLevel()
        
        expect(a._id).toBe "000"
        expect(b._id).toBe "111"
        expect(Categories.collection.findOne).toHaveBeenCalledWith
            parent: ""
        expect(Categories.collection.find).toHaveBeenCalledWith
            parent: "000"

    it "should be possible to find all categories", ->
        spyOn Categories.collection, "find"
            .and.returnValue _id: "111"
                
        a = Categories.findAll()
        
        expect(a._id).toBe "111"
        expect(Categories.collection.find).toHaveBeenCalledWith {}

    it "should be possible to find all children", ->
        spyOn Categories.collection, "find"
            .and.returnValue _id: "111"
                
        base = Categories.collection._transform _id: "000", parent: ""
        a = base.findChildren()
        
        expect(a._id).toBe "111"
        expect(Categories.collection.find).toHaveBeenCalledWith parent: "000"

    it "should be able to check whether it is a leaf", ->
        spyOn Categories.collection, "findOne"
            .and.callFake (req) ->
                if req.parent == "000"
                    "999"
                else 
                    undefined
                
        top = Categories.collection._transform _id: "000"
        leaf = Categories.collection._transform _id: "111"
        
        expect(top.isLeaf()).toBe false
        expect(leaf.isLeaf()).toBe true
        expect(Categories.collection.findOne).toHaveBeenCalledWith parent: "000"
        expect(Categories.collection.findOne).toHaveBeenCalledWith parent: "111"
