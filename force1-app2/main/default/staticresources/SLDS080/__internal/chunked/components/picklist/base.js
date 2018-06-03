var SLDS=webpackJsonpSLDS([37,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123],{0:function(e,t){e.exports=React},100:function(e,t,l){"use strict";Object.defineProperty(t,"__esModule",{value:!0}),t.states=t.Context=void 0;var n=function(e){return e&&e.__esModule?e:{default:e}}(l(0)),o=l(8),i=l(9),a=function(e){return n.default.createElement(o.Listbox,{"aria-label":e.heading?e.heading:null,className:"slds-dropdown slds-dropdown_fluid",vertical:!0},e.heading?n.default.createElement("li",{role:"presentation",className:"slds-listbox__item"},n.default.createElement("span",{className:"slds-media slds-listbox__option slds-listbox__option_plain",role:"presentation",id:"listbox-option-unique-id-00"},n.default.createElement("h3",{className:"slds-text-title_caps",role:"presentation"},e.heading))):null,n.default.createElement(o.ListboxItem,null,n.default.createElement(o.Option,{id:"listbox-option-unique-id-01",title:"Option A",focused:e.focused,selected:e.optionOneSelected})),n.default.createElement(o.ListboxItem,null,n.default.createElement(o.Option,{id:"listbox-option-unique-id-02",title:"Option B",selected:e.optionTwoSelected})),n.default.createElement(o.ListboxItem,null,n.default.createElement(o.Option,{id:"listbox-option-unique-id-03",title:"Option ABCDEFGHIJKLMNOPQRSTUVWXYZ",selected:e.optionThreeSelected})))};t.Context=function(e){return n.default.createElement("div",{style:{height:"14rem"}},e.children)};t.default=n.default.createElement(o.ComboboxContainer,{className:"slds-combobox-picklist",containerClassName:"slds-size_small",inputIcon:"right",inputIconRightSymbol:"down",listbox:n.default.createElement(a,null),readonly:!0});t.states=[{id:"focused",label:"Focused",element:n.default.createElement(o.ComboboxContainer,{containerClassName:"slds-size_small",isOpen:!0,inputIcon:"right",inputIconRightSymbol:"down",listbox:n.default.createElement(a,null),readonly:!0}),script:"\n      document.getElementById('combobox-unique-id').focus()\n    "},{id:"open-item-focused",label:"Open - Item Focused",element:n.default.createElement(o.ComboboxContainer,{containerClassName:"slds-size_small",isOpen:!0,inputIcon:"right",inputIconRightSymbol:"down",listbox:n.default.createElement(a,{focused:!0}),"aria-activedescendant":"listbox-option-unique-id-01",readonly:!0})},{id:"open-option-selected",label:"Open - Option Selected",element:n.default.createElement(o.ComboboxContainer,{containerClassName:"slds-size_small",isOpen:!0,inputIcon:"right",inputIconRightSymbol:"down",value:"Option A",listbox:n.default.createElement(a,{optionOneSelected:!0}),readonly:!0})},{id:"open-options-selected",label:"Open - Option(s) Selected",element:n.default.createElement(o.ComboboxContainer,{containerClassName:"slds-size_small",isOpen:!0,inputIcon:"right",inputIconRightSymbol:"down",value:"2 Options Selected",listbox:n.default.createElement(a,{optionOneSelected:!0,optionTwoSelected:!0}),readonly:!0})},{id:"closed-option-selected",label:"Option Selected",element:n.default.createElement(o.ComboboxContainer,{containerClassName:"slds-size_small",inputIcon:"right",inputIconRightSymbol:"down",value:"Option A",listbox:n.default.createElement(a,{focused:!0,optionOneSelected:!0}),readonly:!0})},{id:"closed-options-selected",label:"Option(s) Selected",element:n.default.createElement(o.ComboboxContainer,{containerClassName:"slds-size_small",inputIcon:"right",inputIconRightSymbol:"down",value:"2 Options Selected",listbox:n.default.createElement(a,{optionOneSelected:!0,optionTwoSelected:!0}),readonly:!0},n.default.createElement(o.Listbox,{id:"listbox-selections-unique-id","aria-label":"Selected Options:",className:"slds-p-top_xxx-small",horizontal:!0},n.default.createElement(o.ListboxItem,null,n.default.createElement(i.ListboxPill,{label:"Option A",tabIndex:"0"})),n.default.createElement(o.ListboxItem,null,n.default.createElement(i.ListboxPill,{label:"Option B"}))))},{id:"group-heading",label:"Group heading label",element:n.default.createElement(o.ComboboxContainer,{containerClassName:"slds-size_small",isOpen:!0,inputIcon:"right",inputIconRightSymbol:"down",value:"Option A",listbox:n.default.createElement(a,{optionOneSelected:!0,heading:"Recently Viewed"}),readonly:!0})}]}},[100]);