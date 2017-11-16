## Should I stay or should I Go?
Ralf Wirdemann - kommitment GmbH & Co. KG

Note:
Mein Name ist Ralf Wirdemann, das ist meine Firma "kommitment" und heute geht es um Go.

Kurz zu mir: Ich arbeite als Softwarecoach, d.h. helfe Teams bei der Produktentwicklung. Ich bin dabei weder reiner Agile Coach, noch reiner Programmierer, sondern versuche vielmehr eine ganzheitliche Sicht auf Teams, Prozesse und Technolgien einzunehmen.

Mein Job ist es Teams sowhl methodisch als auch technisch auf Spur zu bringen und dazu gehört es für mich auch, Technisch immer dran zu bleiben, und sich z.B. neue Programmiersprachen anzugucken.

Go umtreibt mich seit gut zwei Jahren, initialer Funke: Freunde, Konferenz, Paris.

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
- (RACSignal *)getAllGroupsV2 {
   
    RACSignal *signal = [communicator get:@"http://picue.de/groups"];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [signal subscribeNext:^(NSDictionary *data) {
            NSManagedObjectContext *context =
			    [PQCoreDataManager sharedManager].managedContext;
            [PQGroup createOrUpdateWithContext:context data:data];
        } error:^(NSError *error){
            [subscriber sendError:error];
        } completed:^{
            [[PQCoreDataManager sharedManager] saveContext];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
func getAllGroupsV2() {
	if resp, err := http.Get("http://picue.de/groups"); err != nil {
		panic(err)
	}

	var groups []*domain.Group
	json := resp.Body
	decoder := json.NewDecoder(json)	
	decode.Decode(&groups)
	database.CreateGroups(&groups)
}
</code></pre>

---

# Lesbarkeit

Note:
- Go ist auf Lesbarkeit optimiert
- lt. Uncle Bob liegt das Verhältnis 10:1
- und wir lesen nicht nur unseren eigenen Code
- sondern unser Code wird auch von vielen anderen gelesen
- Leserbarkeit ist ein Schlüssel für produktive Teams

---

# Meine Geschichte 

---

# 1992

<pre><code class="c" data-trim>
int main() {
	printf("Hello World\n");
	return 0;
}
</code></pre>

---

# 1994

<pre><code class="c++" data-trim data-noescape>
main() {
	cout << "Hello World" << endl;
}
</code></pre>

---

# 2000

<pre><code class="java" data-trim data-noescape>
public class HelloWorld {
 
	public static void main (String[] args) {
		System.out.println("Hello World");
	}
}
</code></pre>

---

# 2008

<pre><code class="ruby" data-trim data-noescape>
puts 'Hello World'
</code>

---

# 2016
<pre><code class="objective-c" data-trim data-noescape>
int main (int argc, const char * argv[]) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSLog(@"Hello World!");
	[pool drain];
	return 0;
}
</code></pre>

---

# 2016

<pre><code class="go" data-trim data-noescape>
func main() {
	print("Hello World\n")
}

<span class="fragment">
int main() {
	printf("Hello World\n");
	return 0;
}
</span>
</code></pre>

Note:
- am ende war es dann auch das objective-c beispiel, was nochmal zusätzlich motiviert hat, go zu lernen

---

## 40 Jahre später

![optional caption text](figures/c-book-go-book.png)

---

## Die Programmiersprache Go

<p class="fragment">Geschichte</p>
<p class="fragment">Syntax</p>
<p class="fragment">Eigenschaften</p>
<p class="fragment">Wer, wofür, warum?</p>
<p class="fragment">Was mir nicht so gefällt</p>
<p class="fragment">Fazit</p>

---

# Geschichte

<p class="fragment">2007: Frust Komplextität von Google-Software</p>
<p class="fragment">Ken Thompson, Rob Pike, Robert Griesemer</p>
<p class="fragment">Idee: Einfache, compilierbare Programmiersprache, die heutigen Rechensystemen gerecht wird</p>
<p class="fragment">2009: Erste öffentliche Version im November</p>

Note:
- Frust:
  - Schwer zu managende Abhängigkeiten
  - langsame Builds
  - jeder nutzt unterschiedliche Subsets der Sprache
  - Updates sind teuer 
- Thomposon: Unix, erste Shell, UTF-8, Plan 9
- Rob Pike: Unix, Plan 9, UTF-8
- Griesemer: V8 JavaScript Engine, Java Hotspot VM

---

## Statisch getypt

<pre><code class="go" data-trim data-noescape>    
s := "Hallo"      // string

i := 42           // int

f := 3.142        // float64

g := 0.867 + 0.5i // complex128
</code></pre>

Note:
- Objekte haben Typ
- Sicherstellen, das z.B. Variablen, Funktionen korrekt verwendet werden
- Ziel: Vermeidung von Laufzeitfehlern
- Steht nicht im Weg:
  - vermeidet typischer Fehler der dynamischen Programmierung
  - steht aber nicht im Weg

---

## Only 25 Keywords

<pre class="stretch"><code class="go" data-trim data-noescape>    
  break        default          func        interface       select 
  
  case         defer            go          map             struct 

  chan         else             goto        package         switch 

  const        fallthrough      if          range           type

  continue     for              import      return          var
</code></pre>

Note:
- Java hat 50
- Swift hat 58
- C++
- Spec ist 40 Seiten lang

---

## No fancy Stuff

<p class="fragment">Keine Enums</p>
<p class="fragment">Keine Generics</p>
<p class="fragment">Keine Optionals</p>
<p class="fragment">Kein protected</p>

---

# A tour of go

---

# Packages

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
<mark>$GOROOT/picue/domain/groups.go</mark>                   
                     media.go    
</code></pre>

Note:
- alle Dateien in einem Verzeichnis gehören zum selben Package
- Letzer Teil des Pfadnames
- ausnahme Main: Package muss main heissen, sonst wird die main Funktion nicht ausgeführt

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
$GOROOT/picue/<mark>domain/groups.go</mark>
                     media.go   

<mark>package domain</mark>

type Group struct {
...
}
</pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
$GOROOT/picue/domain/groups.go                      
                     <mark>media.go</mark>

package domain

type Group struct {
...
}

<mark>package domain</mark>

type Media struct {
...
}
</pre>

---

# Functions

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

<mark>func swap(x int, y int) (int, int) {</mark>
	return y, x
}

func main() {
	x, y := swap(2, 1)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

func swap(x int, y int) (int, int) {
	return y, x
}

<mark>func main() {</mark>
	x, y := swap(2, 1)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

func swap(x int, y int) (int, int) {
	return y, x
}

func main() {
	<mark>x, y := swap(2, 1)</mark>
}
</code></pre>

---

# Imports

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

<mark>import "fmt"</mark>

func main() {
	fmt.Println("Hello")
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

func main() {
	<mark>fmt.Println("Hello")</mark>
}
</code></pre>

---

# Variablen

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

<mark>var name string</mark>

func main() {
	name = "Jax"
	fmt.Println("Hello, ", name)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

var name string

func main() {
	<mark>name = "Jax"</mark>
	fmt.Println("Hello, ", name)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

func main() {
	<mark>name := "Jax"</mark>
	fmt.Println("Hello, ", name)
}
</code></pre>

---

# Typen

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

<mark>type message string</mark>

var m message

func main() {
	m = "Hello, Jax"
	fmt.Println(m)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type message string

<mark>var m message</mark>

func main() {
	m = "Hello, Jax"
	fmt.Println(m)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type message string

var m message

func main() {
	<mark>m = "Hello, Jax"</mark>
	fmt.Println(m)
}
</code></pre>

---

## Zusammengesetzte Typen 

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

<mark>type greeting struct {</mark>
	message string
	greetee string
}

func main() {
	g := greeting{message: "Hello", greetee: "Jax"}
	fmt.Println(g.message, g.greetee)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type greeting struct {
    <mark>message string</mark>	
	greetee string
}

func main() {
	g := greeting{message: "Hello", greetee: "Jax"}
	fmt.Println(g.message, g.greetee)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type greeting struct {
	message string
	<mark>greetee string</mark>
}

func main() {
	g := greeting{message: "Hello", greetee: "Jax"}
	fmt.Println(g.message, g.greetee)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type greeting struct {
	message string
	greetee string
}

func main() {
	<mark>g := greeting{message: "Hello", greetee: "Jax"}</mark>
	fmt.Println(g.message, g.greetee)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type greeting struct {
	message string
	greetee string
}

func main() {
	g := greeting{message: "Hello", greetee: "Jax"}
	fmt.Println(<mark>g.message</mark>, g.greetee)
}
</code></pre>

---

# Methods

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type greeting struct {
	message string
	greetee string
}

<mark>func print(g greeting) {</mark>
	fmt.Println(g.message, g.greetee)
}

func main() {
	g := greeting{message: "Hello", greetee: "Jax"}
	print(g)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type greeting struct {
	message string
	greetee string
}

func print(<mark>g greeting</mark>) {
	fmt.Println(g.message, g.greetee)
}

func main() {
	g := greeting{message: "Hello", greetee: "Jax"}
	print(g)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type greeting struct {
	message string
	greetee string
}

func <mark>(g greeting)</mark> print() {
	fmt.Println(g.message, g.greetee)
}

func main() {
	g := greeting{message: "Hello", greetee: "Jax"}
	// print(g)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type greeting struct {
	message string
	greetee string
}

func (g greeting) print() {
	fmt.Println(g.message, g.greetee)
}

func main() {
	<mark>g := greeting{message: "Hello", greetee: "Jax"}</mark>
	// print(g)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type greeting struct {
	message string
	greetee string
}

func (g greeting) print() {
	fmt.Println(g.message, g.greetee)
}

func main() {
	g := greeting{message: "Hello", greetee: "Jax"}
	<mark>// print(g)</mark>
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type greeting struct {
	message string
	greetee string
}

func (g greeting) print() {
	fmt.Println(g.message, g.greetee)
}

func main() {
	g := greeting{message: "Hello", greetee: "Jax"}
	<mark>g.print()</mark>
}
</code></pre>

---

# Seiteneffekte

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>

package main

import "fmt"

type greeting struct {
	message      string
	greetee      string
	<mark>timesPrinted int</mark>
}

func (g greeting) print() {
	fmt.Println(g.message, g.greetee)
	g.timesPrinted++
}

func main() {
	g := greeting{message: "Hello", greetee: "Jax"}
	g.print()
	fmt.Printf("times printed: %d", g.timesPrinted)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type greeting struct {
	message      string
	greetee      string
	timesPrinted int
}

func (g greeting) print() {
	fmt.Println(g.message, g.greetee)
	<mark>g.timesPrinted++</mark>
}

func main() {
	g := greeting{message: "Hello", greetee: "Jax"}
	g.print()
	fmt.Printf("times printed: %d", g.timesPrinted)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type greeting struct {
	message      string
	greetee      string
	timesPrinted int
}

func (g greeting) print() {
	fmt.Println(g.message, g.greetee)
	g.timesPrinted++
}

func main() {
	g := greeting{message: "Hello", greetee: "Jax"}
	<mark>g.print()</mark>
	fmt.Printf("times printed: %d", g.timesPrinted)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type greeting struct {
	message      string
	greetee      string
	timesPrinted int
}

func (g greeting) print() {
	fmt.Println(g.message, g.greetee)
	g.timesPrinted++
}

func main() {
	g := greeting{message: "Hello", greetee: "Jax"}
	g.print()
	<mark>fmt.Printf("times printed: %d", g.timesPrinted)</mark>
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type greeting struct {
	message      string
	greetee      string
	timesPrinted int
}

func (g greeting) print() {
	fmt.Println(g.message, g.greetee)
	g.timesPrinted++
}

func main() {
	g := greeting{message: "Hello", greetee: "Jax"}
	g.print()
	fmt.Printf("times printed: %d", g.timesPrinted) <mark> => 0</mark>
}
</code></pre>

---

# Pointer

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

func inc(px *int) {
	*px++
}

func main() {
	<mark>x := 1</mark>
	p := &x
	inc(p)
	fmt.Printf("x: %d", *p)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

func inc(px *int) {
	*px++
}

func main() {
	x := 1
	<mark>p := &x</mark>
	inc(p)
	fmt.Printf("x: %d", *p)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

func inc(px *int) {
	*px++
}

func main() {
	x := 1
	p := &x
	<mark>inc(p)</mark>
	fmt.Printf("x: %d", *p)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

<mark>func inc(px *int) {</mark>
	*px++
}

func main() {
	x := 1
	p := &x
	inc(p)
	fmt.Printf("x: %d", *p)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

func inc(px *int) {
	<mark>*px++</mark>
}

func main() {
	x := 1
	p := &x
	inc(p)
	fmt.Printf("x: %d", *p)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

func inc(px *int) {
	*px++
}

func main() {
	x := 1
	p := &x
	inc(p)
	fmt.Printf("x: %d", <mark>*p</mark>)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

func inc(px *int) {
	*px++
}

func main() {
	x := 1
	p := &x
	inc(p)
	fmt.Printf("x: %d", *p) <mark> => x: 2</mark>
}
</code></pre>

---

# Pointer Receiver

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type greeting struct {
	message      string
	greetee      string
	timesPrinted int
}

func (g *greeting) print() {
	fmt.Println(g.message, g.greetee)
	g.timesPrinted++
}

func main() {
	<mark>g := &greeting{message: "Hello", greetee: "Jax"}</mark>
	g.print()
	fmt.Printf("times printed: %d", g.timesPrinted)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type greeting struct {
	message      string
	greetee      string
	timesPrinted int
}

func (g *greeting) print() {
	fmt.Println(g.message, g.greetee)
	g.timesPrinted++
}

func main() {
	g := &greeting{message: "Hello", greetee: "Jax"}
	<mark>g.print()</mark>
	fmt.Printf("times printed: %d", g.timesPrinted)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type greeting struct {
	message      string
	greetee      string
	timesPrinted int
}

<mark>func (g *greeting) print() {</mark>
	fmt.Println(g.message, g.greetee)
	g.timesPrinted++
}

func main() {
	g := &greeting{message: "Hello", greetee: "Jax"}
	g.print()
	fmt.Printf("times printed: %d", g.timesPrinted)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type greeting struct {
	message      string
	greetee      string
	timesPrinted int
}

func (g *greeting) print() {
	fmt.Println(g.message, g.greetee)
	<mark>g.timesPrinted++</mark>
}

func main() {
	g := &greeting{message: "Hello", greetee: "Jax"}
	g.print()
	fmt.Printf("times printed: %d", g.timesPrinted)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type greeting struct {
	message      string
	greetee      string
	timesPrinted int
}

func (g *greeting) print() {
	fmt.Println(g.message, g.greetee)
	g.timesPrinted++
}

func main() {
	g := &greeting{message: "Hello", greetee: "Jax"}
	g.print()
	<mark>fmt.Printf("times printed: %d", g.timesPrinted)</mark>
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import "fmt"

type greeting struct {
	message      string
	greetee      string
	timesPrinted int
}

func (g *greeting) print() {
	fmt.Println(g.message, g.greetee)
	g.timesPrinted++
}

func main() {
	g := &greeting{message: "Hello", greetee: "Jax"}
	g.print()
	fmt.Printf("times printed: %d", g.timesPrinted) <mark>=> 1</mark>
}
</code></pre>

---

# Interfaces

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
<mark>type Printable interface {</mark>
	print() string
}

type greeting struct {
	message      string
	greetee      string
}

func (g *greeting) print() string {
	return fmt.Sprintf("", g.message, g.greetee)
}

func printOnConsole(printable Printable)  {
	fmt.Printf("=> %s", printable.print());
}

func main() {
	g := &greeting{message: "Hello", greetee: "Jax"}
	printOnConsole(g)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type Printable interface {
	<mark>print() string</mark>
}

type greeting struct {
	message      string
	greetee      string
}

func (g *greeting) print() string {
	return fmt.Sprintf("", g.message, g.greetee)
}

func printOnConsole(printable Printable)  {
	fmt.Printf("=> %s", printable.print());
}

func main() {
	g := &greeting{message: "Hello", greetee: "Jax"}
	printOnConsole(g)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type Printable interface {
	print() string
}

<mark>type greeting struct {</mark>
	message      string
	greetee      string
}

func (g *greeting) print() string {
	return fmt.Sprintf("", g.message, g.greetee)
}

func printOnConsole(printable Printable)  {
	fmt.Printf("=> %s", printable.print());
}

func main() {
	g := &greeting{message: "Hello", greetee: "Jax"}
	printOnConsole(g)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type Printable interface {
	print() string
}

type greeting struct {
	message      string
	greetee      string
}

<mark>func (g *greeting) print() string {</mark>
	return fmt.Sprintf("", g.message, g.greetee)
}

func printOnConsole(printable Printable)  {
	fmt.Printf("=> %s", printable.print())
}

func main() {
	g := &greeting{message: "Hello", greetee: "Jax"}
	printOnConsole(g)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type Printable interface {
	print() string
}

type greeting struct {
	message      string
	greetee      string
}

func (g *greeting) print() string {
	return fmt.Sprintf("", g.message, g.greetee)
}

<mark>func printOnConsole(printable Printable)  {</mark>
	fmt.Printf("=> %s", printable.print())
}

func main() {
	g := &greeting{message: "Hello", greetee: "Jax"}
	printOnConsole(g)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type Printable interface {
	print() string
}

type greeting struct {
	message      string
	greetee      string
}

func (g *greeting) print() string {
	return fmt.Sprintf("", g.message, g.greetee)
}

func printOnConsole(printable Printable)  {
	fmt.Printf("=> %s", <mark>printable.print()</mark>)
}

func main() {
	g := &greeting{message: "Hello", greetee: "Jax"}
	printOnConsole(g)
}
</code></pre>

Note:
- Typ erfüllt Interface, wenn er alle Methoden implementiert
- Typ muss Interface nicht deklarierern

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type Printable interface {
	print() string
}

type greeting struct {
	message      string
	greetee      string
}

func (g *greeting) print() string {
	return fmt.Sprintf("", g.message, g.greetee)
}

func printOnConsole(printable Printable)  {
	fmt.Printf("=> %s", printable.print());
}

func main() {
	<mark>g := &greeting{message: "Hello", greetee: "Jax"}</mark>
	printOnConsole(g)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type Printable interface {
	print() string
}

type greeting struct {
	message      string
	greetee      string
}

func (g *greeting) print() string {
	return fmt.Sprintf("", g.message, g.greetee)
}

func printOnConsole(printable Printable)  {
	fmt.Printf("=> %s", printable.print());
}

func main() {
	g := &greeting{message: "Hello", greetee: "Jax"}
	<mark>printOnConsole(g)</mark>
}
</code></pre>

---

# Verzögerungen

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
func main() {
	if file, err := os.Open("aareal.txt"); err == nil {
		<mark>defer file.Close()</mark>

		scanner := bufio.NewScanner(file)
		for scanner.Scan() {
			bank := service.Parse(scanner.Text())
			fmt.Printf("%v", bank)
		}
	} else {
		log.Fatal(err)
	}
}
</code></pre>

Note:
- Verzögerte Ausführung: wenn die aufgerufene Funktion endet
- Lokalität: Ich vergesse es nicht, sehe den Bezug
- Ausführung nicht garantiert (anders als finally)

---

# Go auf einer Seite

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
<mark>package main</mark>
import "fmt"

type Dog struct {
	name        string
	timesBarked int
}

type Animal interface { bark() }

func (d *Dog) bark() {
	fmt.Printf("I am %s", d.name)
	d.timesBarked++
}

func sayHello(animal Animal) {
	animal.bark()
}

func main() {
	kalle := &Dog{name: "Kalle"}
	sayHello(kalle)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main
<mark>import "fmt"</mark>

type Dog struct {
	name        string
	timesBarked int
}

type Animal interface { bark() }

func (d *Dog) bark() {
	fmt.Printf("I am %s", d.name)
	d.timesBarked++
}

func sayHello(animal Animal) {
	animal.bark()
}

func main() {
	kalle := &Dog{name: "Kalle"}
	sayHello(kalle)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main
import "fmt"

<mark>type Dog struct {</mark>
	name        string
	timesBarked int
}

type Animal interface { bark() }

func (d *Dog) bark() {
	fmt.Printf("I am %s", d.name)
	d.timesBarked++
}

func sayHello(animal Animal) {
	animal.bark()
}

func main() {
	kalle := &Dog{name: "Kalle"}
	sayHello(kalle)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main
import "fmt"

type Dog struct {
	name        string
	timesBarked int
}

<mark>type Animal interface { bark() }</mark>

func (d *Dog) bark() {
	fmt.Printf("I am %s", d.name)
	d.timesBarked++
}

func sayHello(animal Animal) {
	animal.bark()
}

func main() {
	kalle := &Dog{name: "Kalle"}
	sayHello(kalle)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main
import "fmt"

type Dog struct {
	name        string
	timesBarked int
}

type Animal interface { bark() }

<mark>func (d *Dog) bark() {</mark>
	fmt.Printf("I am %s", d.name)
	d.timesBarked++
}

func sayHello(animal Animal) {
	animal.bark()
}

func main() {
	kalle := &Dog{name: "Kalle"}
	sayHello(kalle)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main
import "fmt"

type Dog struct {
	name        string
	timesBarked int
}

type Animal interface { bark() }

func (d *Dog) bark() {
	fmt.Printf("I am %s", d.name)
	d.timesBarked++
}

<mark>func sayHello(animal Animal) {</mark>
	animal.bark()
}

func main() {
	kalle := &Dog{name: "Kalle"}
	sayHello(kalle)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main
import "fmt"

type Dog struct {
	name        string
	timesBarked int
}

type Animal interface { bark() }

func (d *Dog) bark() {
	fmt.Printf("I am %s", d.name)
	d.timesBarked++
}

func sayHello(animal Animal) {
	animal.bark()
}

func main() {
	<mark>kalle := &Dog{name: "Kalle"}</mark>
	sayHello(kalle)
}
</code></pre>

---

## Go - Spracheigenschaften

<p class="fragment">Objektorientierte Programmierung</p>
<p class="fragment">Funktionale Programmierung</p>
<p class="fragment">Concurrency</p>

---

# Kapselung

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
<mark>package a</mark>

var x int
var X int

type s struct {}
type S struct {}

func foo() {
	...
}

func Foo() {
	...
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package a

<mark>var x int</mark>
var X int

type s struct {}
type S struct {}

func foo() {
	...
}

func Foo() {
	...
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package a

var x int
<mark>var X int</mark>

type s struct {}
type S struct {}

func foo() {
	...
}

func Foo() {
	...
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package a

var x int
var X int

<mark>type s struct {}</mark>
type S struct {}

func foo() {
	...
}

func Foo() {
	...
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package a

var x int
var X int

type s struct {}
<mark>type S struct {}</mark>

func foo() {
	...
}

func Foo() {
	...
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package a

var x int
var X int

type s struct {}
type S struct {}

<mark>func foo() {</mark>
	...
}

func Foo() {
	...
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package a

var x int
var X int

type s struct {}
type S struct {}

func foo() {
	...
}

<mark>func Foo()</mark> {
	...
}
</code></pre>

---

# Vererbung

Note:
- als ich mit OO angefangen habe, war Vererbung der neue heisse Scheiss

---

## Java

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
public class A {

    public void print() {
        ...
    }
}

public class B extends A {
}

B b = new B();
b.print();
</code></pre>

---

## Go
<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
<mark>type A struct {</mark>
	Count int
}

type B struct {
	A
}

func (a A) print() {
    ...
}

b := B{}
b.print()  // Not allowed in Java
b.Count = 12
</code></pre>

---

## Go
<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type A struct {
	Count int
}

<mark>type B struct {</mark>
	A
}

func (a A) print() {
    ...
}

b := B{}
b.print()  // Not allowed in Java
b.Count = 12
</code></pre>

---

## Go
<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type A struct {
	Count int
}

type B struct {
	<mark>A</mark>
}

func (a A) print() {
    ...
}

b := B{}
b.print()  // Not allowed in Java
b.Count = 12
</code></pre>

---

## Go
<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type A struct {
	Count int
}

type B struct {
	A
}

<mark>func (a A) print() {</mark>
    ...
}

b := B{}
b.print()  // Not allowed in Java
b.Count = 12  
</code></pre>

---

## Go
<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type A struct {
	Count int
}

type B struct {
	A
}

func (a A) print() {
    ...
}

b := B{}
<mark>b.print()</mark>  // Not allowed in Java
b.Count = 12
</code></pre>

---

## Go
<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type A struct {
	Count int
}

type B struct {
	A
}

func (a A) print() {
    ...
}

b := B{}
b.print()  // Not allowed in Java
<mark>b.Count = 12</mark>
</code></pre>

Note:
- Eher Komposition als Vererbung
- Pike: If C++ and Java are about type hierarchies and the taxonomy of types, Go is about composition.
- Effective Java: Favor composition over inheritance
- Vererbung ist die engste Form der Kopplung: Änderungen in der Basisklasse wirken sich direkt auf meine Klasse aus.

---

# Polymorphismus

---

## Java
<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
public class A {

    public void print() {
        ...
    }
}

public class B extends A {
}

List&lt;A> l = new ArrayList<>();
l.add(new B());
</code></pre>

---

## Go
<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
<mark>type A struct {</mark>
	a int
}

type B struct {
	A
}

list := [2]A{}
list[0] = A{}
list[1] = B{} // doesn't compile
</code></pre>

---

## Go
<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type A struct {
	a int
}

<mark>type B struct {</mark>
	A
}

list := [2]A{}
list[0] = A{}
list[1] = B{} // doesn't compile
</code></pre>

---

## Go
<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type A struct {
	a int
}

type B struct {
	A
}

<mark>list := [2]A{}</mark>
list[0] = A{}
list[1] = B{} // doesn't compile
</code></pre>

---

## Go
<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type A struct {
	a int
}

type B struct {
	A
}

list := [2]A{}
<mark>list[0] = A{}</mark>
list[1] = B{} // doesn't compile
</code></pre>

---

## Go
<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type A struct {
	a int
}

type B struct {
	A
}

list := [2]A{}
list[0] = A{}
<mark>list[1] = B{}</mark> // doesn't compile
</code></pre>

---

## Polymorphismus via Interfaces

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
<mark>type Animal interface</mark> {
	Talk() string
}

...

kalle := Dog{"Kalle"}
felix := Cat{"Felix"}

animals := [2]Animal{kalle, felix}
for _, v := range animals {
    fmt.Printf("Hey, %s\n", v.Talk())
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type Animal interface {
	Talk() string
}

...

<mark>kalle := Dog{"Kalle"}</mark>
felix := Cat{"Felix"}

animals := [2]Animal{kalle, felix}
for _, v := range animals {
    fmt.Printf("Hey, %s\n", v.Talk())
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type Animal interface {
	Talk() string
}

...

kalle := Dog{"Kalle"}
<mark>felix := Cat{"Felix"}</mark>

animals := [2]Animal{kalle, felix}
for _, v := range animals {
    fmt.Printf("Hey, %s\n", v.Talk())
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type Animal interface {
	Talk() string
}

...

kalle := Dog{"Kalle"}
felix := Cat{"Felix"}

<mark>animals := [2]Animal{kalle, felix}</mark>
for _, v := range animals {
    fmt.Printf("Hey, %s\n", v.Talk())
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type Animal interface {
	Talk() string
}

...

kalle := Dog{"Kalle"}
felix := Cat{"Felix"}

animals := [2]Animal{kalle, felix}
<mark>for _, v := range animals {</mark>
    fmt.Printf("Hey, %s\n", v.Talk())
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type Animal interface {
	Talk() string
}

...

kalle := Dog{"Kalle"}
felix := Cat{"Felix"}

animals := [2]Animal{kalle, felix}
for _, v := range animals {
    fmt.Printf("Hey, %s\n", <mark>v.Talk()</mark>)
}
</code></pre>

Note:
- Interfaces definieren Methoden, die von Typen implementiert werden
- no implements
- Typesafe Ducktyping
- ich kann nachträglich Interfaces deklatieren, ohne den Typ anzufassen

---

# Pointer

<p class="fragment">Waren wir froh, als wir sie los waren</p>
<p class="fragment">NullPointerException</p>
<p class="fragment">Immutability for free</p>
<p class="fragment">Entscheide dich: by value oder by reference</p>
<p class="fragment">Seiteneffekte werden sichtbar</p>
<p class="fragment">Garbage Collection, keine Pointerarithmetik</p>

Note:
- Warum ist Immutability wichtig?
  - weniger Fehleranfällig, da keine ungewollten Seiteneffekte
  - einfach: es gibt nur einen Zustand
  - Threadsafe, können ohne synchronisation geshared werden
- Beispiel in Java: String, BigDecimal
- aber eigene Klassen sind per Default immer mutable
- imutability muss programmiert werden
  - final, private, only getter

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
<mark>type TradeAllocated struct {</mark>
	isin  string
	price float64
}

func (e TradeAllocated) execute() {
	fmt.Printf("Executing %v\n", e)
	e.price = 455.99
}

func main() {
	e := TradeAllocated{isin: "IBM", price: 23.99}
	e.execute()
	fmt.Printf("Trade executed %v", e)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type TradeAllocated struct {
	isin  string
	price float64
}

<mark>func (e TradeAllocated) execute() {</mark>
	fmt.Printf("Executing %v\n", e)
	e.price = 455.99
}

func main() {
	e := TradeAllocated{isin: "IBM", price: 23.99}
	e.execute()
	fmt.Printf("Trade executed %v", e)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type TradeAllocated struct {
	isin  string
	price float64
}

func (e TradeAllocated) execute() {
	fmt.Printf("Executing %v\n", e)
	<mark>e.price = 455.99</mark>
}

func main() {
	e := TradeAllocated{isin: "IBM", price: 23.99}
	e.execute()
	fmt.Printf("Trade executed %v", e)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type TradeAllocated struct {
	isin  string
	price float64
}

func (e TradeAllocated) execute() {
	fmt.Printf("Executing %v\n", e)
	e.price = 455.99
}

func main() {
	<mark>e := TradeAllocated{isin: "IBM", price: 23.99}</mark>
	e.execute()	
	fmt.Printf("Trade executed %v", e)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type TradeAllocated struct {
	isin  string
	price float64
}

func (e TradeAllocated) execute() {
	fmt.Printf("Executing %v\n", e)
	e.price = 455.99
}

func main() {
	e := TradeAllocated{isin: "IBM", price: 23.99}
	<mark>e.execute()</mark>
	fmt.Printf("Trade executed %v", e)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type TradeAllocated struct {
	isin  string
	price float64
}

func (e TradeAllocated) execute() {
	fmt.Printf("Executing %v\n", e)
	e.price = 455.99
}

func main() {
	e := TradeAllocated{isin: "IBM", price: 23.99}
	e.execute()
	fmt.Printf("Trade executed %v", e) <mark>=> price = 23.99</mark> 
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type TradeAllocated struct {
	isin  string
	price float64
}

func (<mark>e *TradeAllocated</mark>) execute() {
	fmt.Printf("Executing %v\n", e)
	e.price = 455.99
}

func main() {
	e := TradeAllocated{isin: "IBM", price: 23.99}
	e.execute()
	fmt.Printf("Trade executed %v", e)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type TradeAllocated struct {
	isin  string
	price float64
}

func (e *TradeAllocated) execute() {
	fmt.Printf("Executing %v\n", e)
	e.price = 455.99
}

func main() {
	e := TradeAllocated{isin: "IBM", price: 23.99}
	e.execute()
	fmt.Printf("Trade executed %v", e) => <mark>price = 455.99</mark>
}
</code></pre>

Note:
- Pointer in Go: Best of both worlds
  - Immutablity -> keine unerwünschten Seiteneffekte
  - explizite Sichtbarkeit von Referenz d.h. Seiteneffekte
- Aber nicht so schlimm wie in C
  - keine Pointer-Arithmetik
  - Garbage Collection

---

# Funktionale Programmierung

Note:
- Go ist Dogmen-frei, untersützt aber OO und Funktionale Programmierung, ohne sich Hybrid zu nennen
- Funktionale Programmierung
  - Funktionen als First Class Objects
  - Seiteneffektfreiheit

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
func main() {
	<mark>f := func(x int) int {</mark>
		return x * x
	}
	result := f(2)
	print(result)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
func main() {
	f := func(x int) int {
		return x * x
	}
	<mark>result := f(2)</mark>
	print(result)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
func foo(<mark>fn func(x int) int</mark>) int {
	return fn(2)
}

func main() {
	f := func(x int) int {
		return x * x
	}
	result := foo(f)
	print(result)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
func foo(fn func(x int) int) int {
	<mark>return fn(2)</mark>
}

func main() {
	f := func(x int) int {
		return x * x
	}
	result := foo(f)
	print(result)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
<mark>type myfunction func(x int) int</mark>

func foo(fn myfunction) int {
	return fn(2)
}

func main() {
	f := func(x int) int {
		return x * x
	}
	result := foo(f)
	print(result)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
type myfunction func(x int) int

func foo(<mark>fn myfunction</mark>) int {
	return fn(2)
}

func main() {
	f := func(x int) int {
		return x * x
	}
	result := foo(f)
	print(result)
}
</code></pre>

---

# Concurrency

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
<mark>func sum(s []int) int {</mark>
	sum := 0
	for _, v := range s {
		sum += v
	}
	return sum
}

println("sum: ", sum(values)) // sum:  124999999750000000
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
func sum(s []int) int {
	sum := 0
	for _, v := range s {
		sum += v
	}
	return sum
}

<mark>println("sum: ", sum(values))</mark> // sum:  124999999750000000
</code></pre>

Note:
- 6.431s

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
func sum(s []int) int {
	sum := 0
	for _, v := range s {
		sum += v
	}
	return sum
}

<mark>s1 := sum(values[0:size/2-1])</mark>
s2 := sum(values[size/2-1:])
println("sum: ", s1 + s2)    // sum: 124999999750000000 
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
func sum(s []int) int {
	sum := 0
	for _, v := range s {
		sum += v
	}
	return sum
}

s1 := sum(values[0:size/2-1])
<mark>s2 := sum(values[size/2-1:])</mark>
println("sum: ", s1 + s2)    // sum: 124999999750000000 
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
func sum(s []int) int {
	sum := 0
	for _, v := range s {
		sum += v
	}
	return sum
}

s1 := sum(values[0:size/2-1])
s2 := sum(values[size/2-1:])
println("sum: ", <mark>s1 + s2</mark>)    // sum: 124999999750000000 
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
func sum(s []int, c chan int) {
	sum := 0
	for _, v := range s {
		sum += v
	}
	c <- sum                  // send result to channel
}

c := make(chan int)
<mark>go</mark> sum(values[0:size/2-1], c)
go sum(values[size/2-1:], c)
s1, s2 := <-c, <-c            // receive value from channel
println("sum: ", s1 + s2)     // sum: 124999999750000000 
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
func sum(s []int, c chan int) {
	sum := 0
	for _, v := range s {
		sum += v
	}
	c <- sum                  // send result to channel
}

<mark>c := make(chan int)</mark>
go sum(values[0:size/2-1], c)
go sum(values[size/2-1:], c)
s1, s2 := <-c, <-c            // receive value from channel
println("sum: ", s1 + s2)     // sum: 124999999750000000 
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
func sum(s []int, c chan int) {
	sum := 0
	for _, v := range s {
		sum += v
	}
	c <- sum                  // send result to channel
}

c := make(chan int)
go sum(values[0:size/2-1], <mark>c</mark>)
go sum(values[size/2-1:], c)
s1, s2 := <-c, <-c            // receive value from channel
println("sum: ", s1 + s2)     // sum: 124999999750000000 
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
func sum(s []int, c chan int) {
	sum := 0
	for _, v := range s {
		sum += v
	}
	<mark>c <- sum</mark>                  // send result to channel
}

c := make(chan int)
go sum(values[0:size/2-1], c)
go sum(values[size/2-1:], c)
s1, s2 := <-c, <-c            // receive value from channel
println("sum: ", s1 + s2)     // sum: 124999999750000000 
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
func sum(s []int, c chan int) {
	sum := 0
	for _, v := range s {
		sum += v
	}
	c <- sum                  // send result to channel
}

c := make(chan int)
go sum(values[0:size/2-1], c)
go sum(values[size/2-1:], c)
<mark>s1, s2 := <-c, <-c</mark>            // receive value from channel
println("sum: ", s1 + s2)     // sum: 124999999750000000 
</code></pre>

Note:
- Die Go-Runtine erzeugt eine Reihe von Threads, die für die Ausführung von von Go Routinen genutzt werden (gem-ultiplexed). Go Routinen werden von der Runtime erzeugt und wieder freigegeben. Das OS weiss nichts von ihnen. Threads werden preemptiv, Go Routinen cooperativ gescheduled. Schedule Zeit für Goroutine ist O(1), d.h. Anzahl hat keine Auswirkung.
- Einfach ausgedrückt: Goroutinen sind leichtgewichtige Abstraktionen basierend auf Threads. Goprogrammierer müssen nichts von Threads wissen.
- Channels are the pipes that connect concurrent goroutines
- By default sends and receives block until both the sender and receiver are ready. 
- By default channels are unbuffered, meaning that they will only accept sends (chan <-) if there is a corresponding receive (<- chan) ready to receive the sent value.

---

## Go Spracheigenschaften Zusammenfassung

<p class="fragment">Komposition statt Vererbung</p>
<p class="fragment">Interfaces</p>
<p class="fragment">Polymorphismus</p>
<p class="fragment">Pointer</p>
<p class="fragment">Funktionale Programmierung</p>
<p class="fragment">Concurrency</p>

---

# Wer nutzt Go?

<p class="fragment">Google</p>
<p class="fragment">Docker</p>
<p class="fragment">Wunderkinder</p>
<p class="fragment">Dropbox</p>
<p class="fragment">Blockchain-Projekte</p>
<p class="fragment">U-Boot Projekte (z.B. Otto)</p>

Note:
- Source: https://github.com/golang/go/wiki/GoUsers
- Google
  - Kubernetes (Container Orchestrierung)
- Wunderlist
  - Rails Monotlith, heute Microservices
    - Many connections when to Devices online gehen
    - Performance and Scalability
    - Warum Go?
      - Easy to learn (watching one talk)
      - Concurrency, Deployment, No external Dependency
      - close c performance
- Dropbox: Performance critical parts from Python to go
  - 15 Go Teams
  - 1.3 Millionen LOC Go

---

# Wofür Go?

---

### Commandline Tools

<img src="figures/cmd-line-tool.png" alt="Drawing" style="width: 780px;"/>

---

### REST APIs und Microservices

<img src="figures/app-type-two.png" alt="Drawing" style="width: 780px;"/>

Note:
- Go für Microservices, weil
  - Networking Library
  - Easy to deploy
  - Performance (compiled into native assembler)
  - Concurrency
  - Robust
- auch: Web-Apps, Commandline Tools, Embedded

---

### Weitere Anwendungen

<p class="fragment">Netzwerkdienste, z.B. RAT, HAT</p>
<p class="fragment">Dateisysteme, z.B. AFS</p>
<p class="fragment">Datenbanken, z.B. Edgestore</p>
<p class="fragment">Messaging</p>
<p class="fragment">oder allgemein DevOp Tools</p>

Note:
- Allgemein: Alles was im Hintergrund läuft und schnell und robust sein muss
- RAT: rate limiting and throttling (Bandbreitenregulierung)
- HAT: memcached replacement
- AFS: file system to replace global Zookeeper
- Edgestore: distributed database
- DevOps Tools:
  - db management tools
  - deployment, restart tools
  - monitoring tools 
  - Go ist so einfach zu schreiben wie Ruby oder Python, aber, ist deshalb einfach zu deployne, crossplattform und sehr schnell

---

### Go 2016 Survey Results

<img src="figures/go-usage-2016.png" alt="Drawing" style="width: 1600px;"/>

---

# Warum Go? 

---

# Produktivität

<p class="fragment">Erlernbarkeit</p>
<p class="fragment">Standards</p>
<p class="fragment">Lesbarkeit</p>
<p class="fragment">Sprachstabil</p>
<p class="fragment">Sprache für Teams</p>

Note:
- Erlernbarkeit:
  - 25 Keywords: Einfach aber Ausrducksstark
  - Chad Fowler: 1 Talk, ich: eher eine Woche
- Standards: 
  - gofmt, Klammersetzung, nur ein for
- Sprachstabil: Syntax seit 1.0 fixed
  - aber: Library Updates
  - Tool-Verbesserungen: Compiler, GC

---

# Typsicherheit

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>

Map&lt;String, List&lt;Contact>> sections =
    new HashMap&lt;String, List&lt;Contact>>();

<span class="fragment">
Map&lt;String, List&lt;Contact>> sections = 
    new HashMap&lt;>();
</span>
<span class="fragment">
sections := make(map[string][]Contact)
</span>

</code>
</pre>

Note:
- die nicht im Weg steht

---

### Performance

<img src="figures/moore__sl_small.png" alt="Drawing" style="width: 740px;"/>

Note:
- Moore's Law läuft aus
- Performanceanforderungen bleiben hoch
- Compiliert
- Schneller Compiler

---

### Deployment

<img src="figures/one-big-binary.png" alt="Drawing" style="width: 780px;"/>

Note:
- compiled to assembler
- Go-Runtime: goroutines, memory allocation, the garbage collector, channels, interfaces, maps, slices
- At linking time, the linker creates a statically linked ELF (or PE or MachO) file which includes the runtime, your program, and every package that your program references. 
- just copy
- no external dependencies

---

### World class Standard Library 

![optional caption text](figures/standard-library.png)

Note:
- 160 Packages: Komprimierung, Bildbearbeitung, Crypto, Database, Math, Strings, Testing

---

# net/http

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import (
	"fmt"
	<mark>"net/http"</mark>
)

func handleRequest(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, World\n")
}

func main() {
	http.HandleFunc("/hello", handleRequest)
	http.ListenAndServe(":8080", nil)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import (
	"fmt"
	"net/http"
)

<mark>func handleRequest(w http.ResponseWriter, r *http.Request) {</mark>
	fmt.Fprintf(w, "Hello, World\n")
}

func main() {
	http.HandleFunc("/hello", handleRequest)
	http.ListenAndServe(":8080", nil)
}
</code></pre>

Note:
- Beispiel für Standard-Bibliothek
- nicht Teil der Sprache, aber Sprache gibt alles her, um nen Webserver zu bauen. Ohne Framework

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import (
	"fmt"
	"net/http"
)

func handleRequest(w http.ResponseWriter, r *http.Request) {
	<mark>fmt.Fprintf(w, "Hello, World\n")</mark>
}

func main() {
	http.HandleFunc("/hello", handleRequest)
	http.ListenAndServe(":8080", nil)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import (
	"fmt"
	"net/http"
)

func handleRequest(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, World\n")
}

func main() {
	<mark>http.HandleFunc("/hello", handleRequest)</mark>
	http.ListenAndServe(":8080", nil)
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package main

import (
	"fmt"
	"net/http"
)

func handleRequest(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, World\n")
}

func main() {
	http.HandleFunc("/hello", handleRequest)
	<mark>http.ListenAndServe(":8080", nil)</mark>
}
</code></pre>

---

# Was nervt?

---

# Error Handling

---

<pre class="stretch"><code class="go" data-trim data-noescape>
func create(a *Activity) {
	
	var res Result
	var err Error
	
	res, err = DB.Exec("insert ...", a.Name)		
	if err != nil {
	    panic(err)
	}
				
    var id int64
	
	id, err = res.LastInsertId()
	if err != nil {
	    panic(err)
	}
	 	 
    activity.Id = id
	
	...
}		
</pre>

---

# Keine Generics

<pre><code class="java" data-trim data-noescape>
List&ltString> l = new ArrayList<>();
Map&lt;String, Media> m = new HashMap<>();

<span class="fragment">
l := [5]string
m := make(map[string]Media)
</span>
</code></pre>

---

# Keine Klassen

<p class="fragment">weniger Strukturvorgaben</p>
<p class="fragment">wohin mit meinen Structs?</p>
<p class="fragment">wohin mit meinen Methoden?</p>
<p class="fragment">wohin mit meinen Funktionen?</p>
<p class="fragment">was wird Funktion, was wird Methode?</p>

---

## Dependency Management 

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
<mark>bin/
	treubuilder</mark>	

pkg/
    linux_amd64/
        bitbucket.org/rwirdemann/treubuilder/
		    database.a

src/
	bitbucket.org/rwirdemann/treubuilder/
		database/
			database.go
		domain/
			models.go
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
bin/
    treubuilder               

<mark>pkg/
	linux_amd64/
		bitbucket.org/rwirdemann/treubuilder/
			database.a</mark>	

src/
	bitbucket.org/rwirdemann/treubuilder/
		database/
			database.go
		domain/
			models.go
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
bin/
    treubuilder               

pkg/
    linux_amd64/
        bitbucket.org/rwirdemann/treubuilder/
		    database.a
			
<mark>src/
	bitbucket.org/rwirdemann/treubuilder/
		database/
			database.go
		domain/
			models.go</mark>	
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package database

import (
	"database/sql"
	"fmt"
	"log"

	<mark>_ "github.com/go-sql-driver/mysql"</mark>
)

func Connect(database string) {
   ...
}
</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
package database

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/go-sql-driver/mysql"
)

func Connect(database string) {
   ...
}

<mark>$ go get github.com/go-sql-driver/mysql</mark>

</code></pre>

---

<pre class="stretch"><code class="nohighlight" data-trim data-noescape>
bin/
    treubuilder               

pkg/
    linux_amd64/
        bitbucket.org/rwirdemann/treubuilder/
		    database.a

src/
	bitbucket.org/rwirdemann/treubuilder/
		database/
			database.go
		domain/
			models.go
<mark>
	github.com/go-sql-driver/
		mysql/
			appengine.go
</mark>	
</code></pre>

Note:
- most debated
- dependency management defined: move code you rely on to libraries
- Pros:
  - Super simple
  - no extra tool
  - ich finde Sourcen super schnell
- Cons: 
  - unterschiedliche Projekte benötigen unterschiedliche Lib-Versionen
  - meine Lib benötigt eine Library in einer bestimmten Version
- Lösungen:
  - godep: 
    - idee: ein zentrale gopath, aber lokale projekte, die ich aus dem gopath das ziehen, was sie brauchen
    - pulls the versions you need from GOPATH to your project
	- godep save

---

| Pluspunkte || Minuspunkte |
| --- || --- |
| Einfachheit || Dependency Management |
| Lesbarkeit || Keine Generics |
| Erlernbarkeit || Fehlerbehandlung |
| Produktivität || Anfangs schwierig für OO-Leute |
| OO + Funktional ||  |
| Concurrency ||  |
| Performance ||  |
| Deployment ||  |

---

# Resourcen

https://tour.golang.org

https://gobyexample.com/

The Go Programming Language

---

# Hey ho, let's Go

## Vielen Dank!

<p>ralf.wirdemann@kommitment.biz</p>