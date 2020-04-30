import Foundation

class VendingMachineProduct {
    var name: String
    var amount: Int
    var price: Double
    var reserved: Bool

    init(name: String, amount: Int, price: Double, reserved: Bool = false) {
        self.name = name
        self.amount = amount
        self.price = price
        self.reserved = reserved
    }
}

enum VendingMachineError: Error {
    case productNotFound
    case productUnavailable
    case insufficientFunds
    case productStuck
    case productReserved
}

extension VendingMachineError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .productNotFound:
            return "Produto não encontrado"
        case .productUnavailable:
            return "Produto não disponível"
        case .insufficientFunds:
            return "Você não tem grana meu caro"
        case .productStuck:
            return "Seu produto ficou preso. Desculpa..."
        case .productReserved:
            return "Produto reservado. Volte em 30 minutos."
        }
    }
}

class VendingMachine {
    private var estoque: [VendingMachineProduct]
    private var money: Double
    
    init(products: [VendingMachineProduct]) {
        self.estoque = products
        self.money = 0
    }
    
    func getProduct(named name: String, with money: Double) throws {
        //TODO: receber o dinheiro e salvar em uma variável
        self.money = money
        //TODO: achar o produto que o cliente quer
        let unsafeProduto = estoque.first { (produto) -> Bool in
            return produto.name == name
        }

        guard let safeProduto = unsafeProduto else { throw VendingMachineError.productNotFound }
        //TODO: ver se ainda tem esse produto

        if safeProduto.reserved == false {
            guard safeProduto.amount > 0 else { throw VendingMachineError.productUnavailable }
            //TODO: ver se o dinheiro é o suficiente pro produto

            guard safeProduto.price <= money else { throw VendingMachineError.insufficientFunds }
            //TODO: entregar o produto
            self.money -= safeProduto.price
            unsafeProduto?.amount -= 1

            if Int.random(in: 0...100) < 10 {
                throw VendingMachineError.productStuck
            }
        } else {
            throw VendingMachineError.productReserved
        }


    }

    func reserve(product named: String) throws {

        for product in estoque {
            if product.name == named {
                product.reserved = true
                return
            }
        }

        throw VendingMachineError.productNotFound
    }
    
    func getTroco() -> Double {
        let money = self.money
        self.money = 0.0

        return money
    }
}

let vendingMachine = VendingMachine(products:
    [VendingMachineProduct(name: "Coca-cola", amount: 20, price: 5),
     VendingMachineProduct(name: "Snickers", amount: 25, price: 7),
     VendingMachineProduct(name: "Banana", amount: 10, price: 50),
     VendingMachineProduct(name: "Anime DVD", amount: 1, price: 999)])

do {
    try vendingMachine.reserve(product: "Anime DVD")
} catch let error as VendingMachineError {
    print(error.localizedDescription)
}

do {
    try vendingMachine.getProduct(named: "Anime DVD", with: 999)
} catch let error as VendingMachineError {
    print(error.localizedDescription)
}

do {
    try vendingMachine.getProduct(named: "Coca-cola", with: 5)
} catch let error as VendingMachineError {
    print(error.localizedDescription)
}

