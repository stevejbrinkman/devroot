/*console.log('Console.log message is here');

let person = {
    name: 'SteveB',
    age: 68
};

//Dot notation
person.name = 'SBrinkman';

//Dynamic assignment
let selection = 'name';
person[selection] = 'Jay';

console.log(person.name);

let selectedColors = ["red", "Blue"];
console.log (selectedColors[0]);
*/
function greet(name, lastName){
    return ('Hello ' + name + ' ' + lastName);
}

function square(numberVal){
    let squareVal = numberVal * numberVal;
    return (squareVal);
}
function myFunction()
         {
             document.write("This is a simple  2.<br />");
         }
//never got this to work.  Use PHP instead
function getfilenames(){
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "/images", true);
    xhr.responseType = 'document';
    xhr.onload = () => {
      if (xhr.status === 200) {
        var elements = xhr.response.getElementsByTagName("a");
        if (elements) return elements
      }
      else {
        alert('Request failed. Returned status of ' + xhr.status);
      }
    }
    xhr.send()
}

//let myNumber = square(16);
//console.log(myNumber);
