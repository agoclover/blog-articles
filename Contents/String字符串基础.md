---
title: String字符串基础
date: 2020-05-10 18:52:40
categories:
- Java
tags:
- String
- 常量池
---



String 类代表字符串, 是一个 `final` 类, 代表不可变 (immutable 或者 constant) 的字符序列. 字符串是常量, 用双引号引起来表示, 它们的值在创建之后不能更改.

String 对象的字符内容是存储在一个不可变的 `char` 型数组中的:

```java
private final char value[];
```

在本文中, **字符串**表示广义的字符串. 但字符串对象又有**两种创建方式**和**存储位置**.

**第一种**是字符串字面值创建对象.

Java 程序中的所有**字符串字面值**都作为 String 类的实例实现, 这句话什么意思呢?  `"abc"` 是一个**字符串字面值**, 以下代码就是为这个字符串字面值创建一个 String 类对象, 当然也只能创建出 String 类对象:

```java
String a = "abc";
```

这也就是第一种创建字符串的方法. 这个是具体怎么实现的呢?

1. 在字符串常量池中找是否有这个**字符串值**的 String 对象. 这个字符串值可以理解为 `equals()` 是否相同, 但并不一定是调用了这么个方法.
2. 如果找到了则返回找到的对象的地址.
3. 如果没有找到则创建一个此字符串值的对象放在字符串常量池中.

所以, 如下代码输出为 `true`:

```java
String a = "123";
String b = "123";
System.out.println(a == b); //true
```

这里的第 2 步, 如果找到了则返回找到的地址, 这里找到的对象其实并不一定存储在常量区, 后面会说到.

**第二种**是调用 Sting 类的构造器, 创建 String 类的对象, 比如:

```java
String c = new String("123");
String d = new String(new char[]{'1', '2', '3'});
System.out.println(c); // 123
System.out.println(d); // 123
```

这两个对象的字面值都是 `"123"`, 但通过 String 构造器生成的对象均在 gc 区, 是不同的对象, 即:

```java
System.out.println(c == d); // false
System.out.println(a == c); //false
System.out.println(a == d); //false
```

我们不妨将其称为**字符串 gc 区对象**.

那么, 一道经典的题目, 以下代码创建了几个 (String 类) 对象 (以下代码与上面无关):

```java
String str = new String("123");
```

首先, 先为字符串字面量 `"123"` 创建一个 String 类的对象, 存储在字符串常量池中, 然后以其未构造函数的实参, 创建了一个 gc 区对象 `str`, 且是字符串值相同, 但不同的两个对象:

```java
System.out.println(str == "123"); //false
System.out.println(str.equals("123")); //true
```

接着看如下两种字符串相加的方式:

```java
String s = new String("s1");
String s1 = new String("s") + new String("2");
```

我们先查看[反编译](http://www.javadecompilers.com)之后的代码:

```java
// Decompiled by Jad v1.5.8e. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.geocities.com/kpdus/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   StringTest.java


public class StringTest
{

    public StringTest()
    {
    }

    public static void main(String args[])
    {
        String s = new String("s1");
        String s1 = (new StringBuilder()).append(new String("s")).append(new String("2")).toString();
    }
}
```

可以看出 `s` 是通过 String 的构造器创建的.

`s1` 是通过先创建一个 `StringBuilder` 然后依次添加 `+` 号**两边的对象**!

所以这段代码创建了多少对象呢?

第一行是两个;

第二行, 首先 `new StringBuilder()` 一个, `"s"` 一个, `new String("s")` 一个, `"2"` 一个, `new String("2")` 一个, `toString()` 一个返回地址给 `s1`, 当然这里面忽略了创建 `StringBuilder` 内部的成员变量对象等.

这个也可以通过 `javap -c StringTest` 看出来.

还有一点, 如果直接是两个字符串字面量相加:

```java
String str = "s" + "t" + "r";
```

则编译器会直接优化为:

```java
String str = "str";
```

其他一切通过 `+` 的方式得到字符串都是通过先创建 `StringBuilder` 再 `append()` 最后 `toString()` 来得到的.

那么上面是先创建三个单独的 `"s"`, `"t"`, `"r"` 对象, 再创建 `"str"` 还是直接只创建一个对象 `"str"` 呢?

要了解这个问题, 先介绍 String 的一个方法 `intern()`. **一般**这个方法是对 gc 区中的字符串对象来用的.

在 JDK 1.7 及以后, `str.intern()` 方法变成了: **先在字符串常量池中找是否有和 `str` 值一样的字符串对象, 如果有直接返回这个已有对象的引用; 如果没有, 则把 `str` 这个 gc 区字符串对象的引用放入字符串常量池中**.

现在我们通过以下这串代码来验证:

```java
String str1 = "123" + "456";
String str2 = new String(new char[]{'1', '2', '3'});
str2.intern();
String str3 = "123";
System.out.println(str3 == str2); //true
```

第 1 行我们暂时不知道是否创建了 `"123"` 这个对象;

第 2 行创建了一个值为 `"123"` 但在 gc 区中的对象;

第 3 行调用 `intern()` 方法, 如果字符串常量池中有值为 `"123"` 的对象, 那么什么也不干; 如果没有, 会把 `str2` 这个对象的引用放入字符串常量池中;

第 4 行 `"123"` 字面量创建对象时会引用字符串常量池中已有的值为 `"123"` 的对象或引用;

第 5 行是关键, 如果 1 行创建了 `"123"` 对象, 则必为 `false`, 如果没有则为 `true`.

结果是 `true`, 说明第 1 行没有创建 `"123"` 而是直接将两个合二为一直接只创建一个字符串对象.

最后再看以下这几行代码:

```java
String h1 = new String("1") + new String("23");
String h2 = new String("12") + new String("3");

String h3 = h1.intern();
String h4 = h2.intern();

String h5 = "123";

System.out.println(h1 == h2); //false
System.out.println(h1 == h3); //true
System.out.println(h1 == h4); //true
System.out.println(h3 == h4); //true
System.out.println(h2 == h3); //false
System.out.println(h2 == h4); //false
System.out.println(h5 == h1); //true
System.out.println(h5 == h2); //false
```

以及:

```java
String h1 = new String("1") + new String("23");
String h2 = new String("12") + new String("3");

String h5 = "123";

String h3 = h1.intern();
String h4 = h2.intern();

System.out.println(h1 == h2); //false
System.out.println(h1 == h3); //false
System.out.println(h1 == h4); //false
System.out.println(h3 == h4); //true
System.out.println(h2 == h3); //false
System.out.println(h2 == h4); //false
System.out.println(h5 == h1); //false
System.out.println(h5 == h2); //false
System.out.println(h5 == h3); //true
System.out.println(h5 == h4); //true
```

知道了 `intern()` 这个函数, 上面的结果就不难理解了.

第一段 `h1.intern();` 执行后, 剩下 `"123"` 指向的都是 `h1`;

第二段 `String h5 = "123";` 在先, 所以之后  `"123"` 指向的都是 `h5`.



**参考资料**

1. [java两个字符串对象相加和字符串字面量比较？ - 海纳的回答 - 知乎](https://www.zhihu.com/question/267818864/answer/329226635) 
2. [一文弄懂String的所有小秘密](https://juejin.im/post/5eb487c2e51d45244e7c2da9?spm=5176.13955521.J_1633660880.9.50a24cfejW7DER)
3. [String：字符串常量池](https://segmentfault.com/a/1190000009888357)
4. [彻底弄懂字符串常量池等相关问题](https://www.cnblogs.com/gxyandwmm/p/9495923.html)



**相关文章-substring()内存泄漏**

1. [Java中substring内存泄露问题](https://blog.csdn.net/itmyhome1990/article/details/77647800)
2. [Java中由substring方法引发的内存泄漏](https://blog.csdn.net/u013256816/article/details/47782491)

