describe "Category", ->
    it "should be created or updated by admin with name, comment, parent and order", ->
        spyOn Categories.collection, "insert"
            .and.returnValue true
        spyOn Categories.collection, "update"
            .and.returnValue true
        spyOn Users, "currentUser"
            .and.returnValue isAdmin: -> true

        expect(Categories.canCreate()).toBe(true)
        expect(Categories.canUpdate()).toBe(true)
        Categories.create "Category 1", "comment1", "foo", 20
        
        cat = Categories.collection._transform _id: "id2", name: "cat2", comment: "comment2", parent: "abc"
        cat.update "cat3", "comment3", "parentNew", 30, true
 
        expect(Users.currentUser).toHaveBeenCalled()
        expect(Categories.collection.insert).toHaveBeenCalledWith
            name: "Category 1",
            comment: "comment1",
            parent: "foo",
            order: 20,
            collapsedByDefault: false
        expect(Categories.collection.update).toHaveBeenCalledWith _id: "id2",
            $set:
                name: "cat3",
                comment: "comment3",
                parent: "parentNew",
                order: 30,
                collapsedByDefault: true
                
    it "should not be created by non-admin", ->
        spyOn Categories.collection, "insert"
            .and.returnValue true
        spyOn Categories.collection, "update"
            .and.returnValue true
        spyOn Users, "currentUser"
            .and.returnValue isAdmin: -> false

        expect(Categories.canCreate()).toBe(false)
        expect(Categories.canUpdate()).toBe(false)
        expect -> Categories.create "Category 1", "comment", "foo"
            .toThrow()
        cat = Categories.collection._transform _id: "id2", name: "cat2", comment: "comment2", parent: "abc"
        expect -> cat.update "cat3", "comment3"
            .toThrow()
 
        expect(Users.currentUser).toHaveBeenCalled()
        expect(Categories.collection.insert).not.toHaveBeenCalled()
        expect(Categories.collection.update).not.toHaveBeenCalled()
                
    it "should be possible to find root and top-level categories", ->
        spyOn Categories.collection, "findOne"
            .and.returnValue _id: "000", findChildren: -> _id: "111"
                
        a = Categories.findRoot()
        b = Categories.findTopLevel()
        
        expect(a._id).toBe "000"
        expect(b._id).toBe "111"
        expect(Categories.collection.findOne).toHaveBeenCalledWith
            parent: ""

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
        expect(Categories.collection.find).toHaveBeenCalledWith parent: "000", {sort: order: 1}

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
            
    it "should be possible to collapse and uncollapse", ->
        spyOn Session, "set"
            .and.returnValue "true"
        spyOn Session, "get"
            .and.callFake (key) ->
                if key == "category_collapsed_abc"
                    return true
                else if key == "category_collapsed_def"
                    return false
                else 
                    return undefined

        abc = Categories.collection._transform _id: "abc", collapsedByDefault: false
        def = Categories.collection._transform _id: "def", collapsedByDefault: true
        abc1 = Categories.collection._transform _id: "abc1", collapsedByDefault: false
        def1 = Categories.collection._transform _id: "def1", collapsedByDefault: true
        abc2 = Categories.collection._transform _id: "abc2"
            
        expect(abc.collapsed()).toBe(true)
        expect(def.collapsed()).toBe(false)
        expect(abc1.collapsed()).toBe(false)
        expect(def1.collapsed()).toBe(true)
        expect(abc2.collapsed()).toBe(false)
        
        abc.invertCollapsed()
        expect(Session.set).toHaveBeenCalledWith "category_collapsed_abc", false
        
    it "should be possible to find all descendats", ->
        spyOn Categories.collection, "find"
            .and.callFake (req, sort) ->
                if req.parent == "a"
                    x = ["aa", "ab"]
                else if req.parent == "aa"
                    x = ["aaa"]
                else if req.parent == "ab"
                    x = ["aba", "abb"]
                else if req.parent == "aba"
                    x = ["abaa"]
                else x =[]
                (Categories.collection._transform _id: id for id in x)
            
        a = Categories.collection._transform _id: "a"
        d = a.findDescendats();
        expect(d).toEqual ["aaa", "aa", "abaa", "aba", "abb", "ab", "a"]
        
        