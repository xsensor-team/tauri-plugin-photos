function n(n,e,t,r){return new(t||(t=Promise))((function(o,u){function i(n){try{a(r.next(n))}catch(n){u(n)}}function c(n){try{a(r.throw(n))}catch(n){u(n)}}function a(n){var e;n.done?o(n.value):(e=n.value,e instanceof t?e:new t((function(n){n(e)}))).then(i,c)}a((r=r.apply(n,e||[])).next())}))}function e(n,e){var t,r,o,u,i={label:0,sent:function(){if(1&o[0])throw o[1];return o[1]},trys:[],ops:[]};return u={next:c(0),throw:c(1),return:c(2)},"function"==typeof Symbol&&(u[Symbol.iterator]=function(){return this}),u;function c(c){return function(a){return function(c){if(t)throw new TypeError("Generator is already executing.");for(;u&&(u=0,c[0]&&(i=0)),i;)try{if(t=1,r&&(o=2&c[0]?r.return:c[0]?r.throw||((o=r.return)&&o.call(r),0):r.next)&&!(o=o.call(r,c[1])).done)return o;switch(r=0,o&&(c=[2&c[0],o.value]),c[0]){case 0:case 1:o=c;break;case 4:return i.label++,{value:c[1],done:!1};case 5:i.label++,r=c[1],c=[0];continue;case 7:c=i.ops.pop(),i.trys.pop();continue;default:if(!(o=i.trys,(o=o.length>0&&o[o.length-1])||6!==c[0]&&2!==c[0])){i=0;continue}if(3===c[0]&&(!o||c[1]>o[0]&&c[1]<o[3])){i.label=c[1];break}if(6===c[0]&&i.label<o[1]){i.label=o[1],o=c;break}if(o&&i.label<o[2]){i.label=o[2],i.ops.push(c);break}o[2]&&i.ops.pop(),i.trys.pop();continue}c=e.call(n,i)}catch(n){c=[6,n],r=0}finally{t=o=0}if(5&c[0])throw c[1];return{value:c[0]?c[1]:void 0,done:!0}}([c,a])}}}async function t(n,e={},t){return window.__TAURI_INTERNALS__.invoke(n,e,t)}function r(){return n(this,void 0,void 0,(function(){return e(this,(function(n){switch(n.label){case 0:return[4,t("plugin:photos|execute")];case 1:return n.sent(),[2]}}))}))}function o(){return n(this,void 0,void 0,(function(){return e(this,(function(n){switch(n.label){case 0:return[4,t("plugin:photos|selectPhotos")];case 1:return[2,n.sent()]}}))}))}"function"==typeof SuppressedError&&SuppressedError,"function"==typeof SuppressedError&&SuppressedError;export{r as execute,o as selectPhotos};
